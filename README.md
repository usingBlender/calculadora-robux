#  ➕➖ Calculadora de Robux ✖️➗

Realiza diversos calculos relacionados com o mercado de troca do Roblox, feito com swift 6.1 no linux.

![GitHub commit activity](https://img.shields.io/github/commit-activity/t/usingBlender/calculadora-robux)

![GitHub License](https://img.shields.io/github/license/usingBlender/calculadora-robux)


# ⚙️ Parametros:
- **--gamepass-reward** `<custo-desejado>`
Calcula o valor recebido pelo vendedor ao vender um gamepass de `<custo-desejado>` valor, contando com a taxa de 30% que o Roblox tira para si.

- **--gamepass-cost** `<recompensa-desejada>`
Calcula o valor de venda necessário para um gamepass com base num valor de recompensa determinado, contando com a taxa de 30% antes mencionada.

- **--currency** `<moeda>`
Troca a moeda de calculo da aplicação.

*Ex: USD, BRL, cny, aud*

- **--devex** `<valor>`
Retorna o valor que o devEX providenciaria para aquela quantia de robux.

- **--hide-purchase-guide**
Esconde o guia de compra para os dois parametros abaixo.

- **--robux** `<robux>`
Esse parametro pede um valor de `<robux>` e diz quanto dinheiro custaria, quanto robux não seria comprável, e como comprar essa quantia com um guia detalhado.

- **--money** `<dinheiro>`
Esse parametro pede um valor de `<dinheiro>` e diz quantos robux isso renderia através da loja, quanto sobraria, e como comprar esses robux com um guia detalhado.

- **--help**
Comando padrão de ajuda, mostra essencialmente essa seção de parametros.

# Instalação

Atualmente o projeto não esta em nenhum administrador de pacotes então acaba sendo altamente **experimental** e extremamente **inconveniente**, o próprio usuário aqui vai precisar buildar o projeto. No entanto, é um processo bem simples.

⚠️ **Você vai precisar da linha de comando do swift obtida pelo meio  oficial [AQUI!](https://www.swift.org/)** ⚠️


```bash
  git clone https://github.com/usingBlender/calculadora-robux

  cd calculadora-robux
  
  swift build
```

A partir daí, você vai buscar a pasta de build, no caso de quem compilar no Linux ou no Mac, a pasta vai estar escondida e pode ser encontrada através do terminal com o seguinte comando.

```bash
  ls -a 
```

No windows, esse comando é diferente.

```powershell
  dir /a
```

Com isso, você deve ter localizado a pasta de build.

Abaixo, fica descrito o processo no linux, o qual não é muito diferente do windows/mac, esse demonstra a funcionalidade de como navegar a pasta de build e executar o programa de forma correta.
```bash
  cd .build

  ls -a

  cd x86_64-unknown-linux-gnu

  cd debug

  ./Calculadora <parametros>
```