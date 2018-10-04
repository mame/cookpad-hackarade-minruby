h = { "alpha" => 1, "bravo" => 2, "charlie" => 3 }
p(h["alpha"])
p(h["bravo"])
p(h["charlie"])
h["bravo"] = 42
h["delta"] = 0
p(h["alpha"])
p(h["bravo"])
p(h["charlie"])
p(h["delta"])
