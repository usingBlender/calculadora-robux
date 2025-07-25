/// Calculates the devEx returns based on a set robux amount
/// - Parameter robuxAmount: The amount of robux to devEx
/// - Returns: The money returns from given amount
func CalculateDevEx(robuxAmount: Int) -> Double {
    let input:Double = Double(robuxAmount)

    return input*0.0035 // taxa atual é $0.0035 USD por 1 RBX no portal de devEx, totalizando $105 USD por 30000 Robux
}
