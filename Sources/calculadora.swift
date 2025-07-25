import ArgumentParser

@main
struct Calculadora:AsyncParsableCommand {
    @Option(name: .long, help: "Coloque o preço do gamepass, receba o valor recebido pelo vendedor, contando com a aplicação das taxas de 30%")
    var gamepassReward:Int? = nil // IMPLEMENTADO

    @Option(name: .long, help: "Coloque o valor desejado a ser recebido, receba o valor do gamepass necessário para tal, contando com a aplicação das taxas de 30%")
    var gamepassCost:Int? = nil // IMPLEMENTADO

    // Coisas de dinheiro abaixo
    @Option(name: .long, help: "Coloque uma moeda de sua escolha (e.g: BRL, usd, aud, CNY)")
    var currency:String = "usd" // IMPLEMENTADO

    @Option(name: .long, help: "Coloque um valor para ver o quanto renderá através do devex (não contando com as taxas de transferência)")
    var devex:Int? = nil // IMPLEMENTADO

    @Flag(name: .long, help: "Utilize para desabilitar os guias de compra nas opções (robux) e (money)")
    var hidePurchaseGuide:Bool = false // IMPLEMENTADO

    @Option(name: .long, help: "Coloque uma quantia de robux para ver quanto estes custarão, contando com um guia de compra")
    var robux:Int? = nil // IMPLEMENTADO

    @Option(name: .long, help: "Cocloque uma quantia de dinheiro para ver quanto esta renderá em robux, contando com um guia de compra")
    var money:Double? = nil // IMPLEMENTADO

    mutating func run() async throws {
        // Bool pra ver se manda a mensagem de ajuda
        var foundFunction:Bool = false 

        // CALCULO DE LIQUIDEZ DE GAMEPASS
        if gamepassReward != nil {
            let reward = CalculateGamepassReward(gamepassPrice:gamepassReward!)

            let output = """
            \n=========================================
            CALCULO DE RECOMPENSA DE GAMEPASS: 

            CUSTO IDEALIZADO: \(gamepassReward!) RBX
            VALOR RECEBIDO: \(reward) RBX

            """

            foundFunction = true
            print(output)
        }

        // CALCULO DE CUSTO DE GAMEPASS
        if gamepassCost != nil {
            let cost = CalculateGamepassCost(desiredReward: gamepassCost!)

            let output = """
            \n=========================================
            CALCULO DE CUSTO DE GAMEPASS:

            CUSTO NECESSÁRIO: \(cost) RBX
            VALOR DESEJADO A SER RECEBIDO: \(gamepassCost!) RBX

            """

            foundFunction = true
            print(output)
        }

        // VERIFICAR SE HOUVE MUDANÇA DE MOEDA
        var rate:Double = 1.0 // base rate pra USD
        if currency != "usd" {
            let manager = CurrencyExchangeManager()

            // muito feio, mas acho que assim funciona do jeito que eu quero que funcione
            var isLoaded = false
            switch (await manager.LoadData()) {
                case .success(let bool):
                    isLoaded = bool
                    break
                case .failure(let error):
                    let errorOutput = """
                    \n=========================================
                    ERRO ENCONTRADO:

                    \(error.localizedDescription)

                    """

                    print(errorOutput)
                    return
            }

            // verificação de validade dos codigos & busca da taxa
            let invalidOutput = """
            \n=========================================
            ERRO ENCONTRADO:

            Código de moeda inválido, siga o padrão (USD, BRL, aud, gbp)

            """

            let validity = manager.VerifyCodeValidity(currencyCode: currency)

            if !validity {
                print(invalidOutput)
                return
            }

            let (foundRate, wasFound) = manager.FindRateByCode(currencyCode: currency)

            if wasFound {
                rate = foundRate
            } else {
                print(invalidOutput)
                return
            }
        }

        // DEVEX
        if devex != nil {
            var payout = CalculateDevEx(robuxAmount: devex!)

            if currency != "usd" {
                payout = payout*rate
            }

            let output = """
            \n=========================================
            CALCULO DE DEVEX:

            ROBUX: \(devex!) RBX
            RECOMPENSA: \(payout.formatted(.currency(code: currency.uppercased())))

            """

            foundFunction = true
            print(output)
        }

        // GUIA ROBUX->DINHEIRO
        if robux != nil {
            var (remainder, mixedTotal, desktopTotal, costBreakdown, costTransactions) = RobuxToMoney(robux: robux!, hideDescription: hidePurchaseGuide, multiplier: rate, currency: currency)

            var output = """
            \n=========================================
            GUIA ROBUX -> DINHEIRO:

            ROBUX (PARA COMPRAR): \(robux!) RBX
            RESTO (NÃO COMPRÁVEL): \(remainder) RBX

            """

            if costTransactions <= 0 {
                output += """
                \n--------------------

                A quantia de robux em questão não permite nenhuma compra, tente um valor maior

                """
            } else {
                if currency != "usd" {
                    mixedTotal = mixedTotal*rate
                    desktopTotal = desktopTotal*rate
                }

                output += """
                \n--------------------

                TOTAL (COMPRAS PC + MOBILE): \(mixedTotal.formatted(.currency(code: currency.uppercased())))
                TOTAL (COMPRAS SOMENTE PC): \(desktopTotal.formatted(.currency(code: currency.uppercased())))

                \n--------------------
                """

                if costBreakdown != nil {
                    output += costBreakdown!
                }
            }

            foundFunction = true
            print(output)
        }

        // GUIA DINHEIRO->ROBUX
        if money != nil {
            var (remainder, mixedTotal, desktopTotal, costBreakdown, costTransactions) = MoneyToRobux(money: money!, hideDescription: hidePurchaseGuide, multiplier: rate, currency: currency)

            var output = """
            \n=========================================
            GUIA DINHEIRO -> ROBUX:

            DINHEIRO (PARA GASTAR): \(money!.formatted(.currency(code: currency.uppercased())))
            RESTO (NÃO GASTÁVEL): \(remainder.formatted(.currency(code: currency.uppercased())))

            """

            if costTransactions <= 0 {
                output += """
                \n--------------------

                A quantia de dinheiro em questão não permite nenhuma compra, tente um valor maior
                """
            } else {
                output += """
                \n--------------------

                TOTAL (COMPRAS PC + MOBILE): \(mixedTotal) RBX
                TOTAL (COMPRAS SOMENTE PC): \(desktopTotal) RBX

                \n--------------------
                """

                if costBreakdown != nil {
                    output += costBreakdown!
                }
            }

            foundFunction = true
            print(output)
        }

        if !foundFunction {
            print("Nenhum parametro detectado, use --help no final para ver os possíveis casos de uso da ferramenta!")
        }
    }
}
