const DEFAULT_CAPACITY = 20;

function calculateSlotAvailability(bookedCount = 0, cartCount = 0, maxCapacity = DEFAULT_CAPACITY) {
  const validBooked = Math.max(0, Number(bookedCount) || 0);
  const validCart = Math.max(0, Number(cartCount) || 0);
  const totalOccupied = validBooked + validCart;

  const remaining = Math.max(0, maxCapacity - totalOccupied);
  const fillRate = Math.min(100, Math.round((totalOccupied / maxCapacity) * 100));
  const isFull = remaining === 0;

  let status = "disponible";
  if (isFull) {
    status = "complet";
  } else if (remaining <= 5) {
    status = "presque_complet";
  }

  return { remaining, isFull, fillRate, status };
}

if (typeof module !== "undefined" && module.exports) {
  module.exports = { calculateSlotAvailability };
}

// Démonstration des 3 cas exigés
if (typeof window === "undefined" && require.main === module) {
  console.log("=== TESTS RÈGLE MÉTIER GYMFLOW ===");
  console.log("1. Cas vide (0 réservé, 0 panier) :", calculateSlotAvailability(0, 0));
  console.log("2. Cas normal (6 réservés, 1 panier) :", calculateSlotAvailability(6, 1));
  console.log("3. Cas limite (20 réservés, 0 panier) :", calculateSlotAvailability(20, 0));
}