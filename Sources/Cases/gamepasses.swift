/// Calculates the reward of a gamepass, rounding it down to the nearest integer
///
/// - Parameter gamepassPrice: The price of the gamepass
/// - Returns: The reward given to the seller accounted for the 30% tax
func CalculateGamepassReward(gamepassPrice: Int) -> Int {
    let gamepass:Double = Double(gamepassPrice)
    let reward:Double = (gamepass*0.7).rounded(.down) // o bixin tá feio mas tá servindo

    return Int(reward)
}

/// Calculates the price needed for a gamepass to give the input reward, rounded up to the nearest integer
///
/// - Parameter desiredReward: The input for the desired reward out of the gamepass
/// - Returns: The price of the gamepass necessary for given reward
func CalculateGamepassCost(desiredReward: Int) -> Int {
    let reward:Double = Double(desiredReward)
    let cost:Double = (reward/0.7).rounded(.up)

    return Int(cost)
}
