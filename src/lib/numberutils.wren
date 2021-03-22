class NumberUtils {
	static mid(min, curr, max) {
		if (curr < min) {
			return min
		}
		if (curr > max) {
			return max
		}
		return curr
	}

	static min(a, b) {
		return a < b ? a : b
	}

	static max(a, b) {
		return a > b ? a : b
	}

	static isBetween(low, curr, high, includeLow, includeHigh) {
		return (includeLow ? low <= curr : low < curr) && (includeHigh ? curr <= high : curr < high)
	}

	static isBetween(low, curr, high) {
		return isBetween(low, curr, high, true, true)
	}
}