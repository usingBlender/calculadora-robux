import Foundation
import FoundationNetworking // :3

class CurrencyExchangeManager {
    // STRUCTS AQUI

    /// Codable base for the exchange rate table
    struct ExchangeRateTable: Codable {
        var date:String
        var usd:[String:Double]
    }

    // PROPRIEDADES AQUI

    /// Holds the exchange rates
    var exchangeRateTable:ExchangeRateTable? = nil

    // INICIALIZADOR(ES)

    init() {}

    // METODOS AQUI

    /// Verifies the validity of a currency code in accordance to the ISO 4217 standard
    /// - Parameter currencyCode: The currency code
    /// - Returns: true if valid, false if not
    func VerifyCodeValidity(currencyCode: String) -> Bool {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        let code = currencyCode.lowercased()
    
        if code.count > 3 || code.count < 3 {
            return false
        } // todo codigo tem 3 letras
    
        for char in code {
            if !alphabet.contains(char) {
                return false
            }
        } // verificar se tá tudo em letra comum minuscula
    
        return true // se nada deu problema então tá de boa
    }

    /// Finds the exchange rate respective to the code
    /// - Parameter currencyCode: The currency code
    /// - Returns: A tuple of a double (the exchange rate) and a bool (if the query failed or not)
    func FindRateByCode(currencyCode: String) -> (Double, Bool) {
        guard let rateTable = exchangeRateTable else {
            print("Tabela de taxas em FindRateByCode() por algum motivo nula")
            return (0.0, false)
        }

        for rate in rateTable.usd {
            if rate.key == currencyCode.lowercased() {
                return (rate.value, true)
            }
        }

        // caso não encontre nenhuma lingua valida, retorne padrão
        return (0.0, false)
    }
    
    /// Loads data, private function, doesn't matter what I write here, documentation is cool
    func LoadData() async -> Result<Bool, Error> {
        guard let url = URL(string: "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json") else {
            return Result.failure(CustomErrors.error("URL em LoadData() por algum motivo nula")) // retornar falha
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let decodedResponse = try? JSONDecoder().decode(ExchangeRateTable.self, from: data) {
                exchangeRateTable = decodedResponse

                return Result.success(true)
            }
        } catch {
            return Result.failure(CustomErrors.error("Erro pegue ao puxar data no bloco try-catch com URLSession em LoadData()"))
        }

        return Result.failure(CustomErrors.error("Função LoadData() por algum motivo não supriu nenhuma condição antes imposta, verificar isso aí"))
    }
}
