class_name HandlingTimingAccumulator
extends RefCounted

# Fixed-memory nearest-rank timing evidence. Bucket values are conservative upper
# bounds; samples above 100 ms retain their exact worst value.

const BUCKET_WIDTH_MS := 0.01
const MAX_BUCKETED_MS := 100.0
const BUCKET_COUNT := 10_000

var sample_count := 0
var sum_ms := 0.0
var worst_ms := 0.0
var overflow_count := 0
var _buckets := PackedInt64Array()


func _init() -> void:
	_buckets.resize(BUCKET_COUNT)


func add_sample(value_ms: float) -> void:
	var measured_ms := maxf(0.0, value_ms)
	sample_count += 1
	sum_ms += measured_ms
	worst_ms = maxf(worst_ms, measured_ms)
	if measured_ms > MAX_BUCKETED_MS:
		overflow_count += 1
		return
	var bucket_index := clampi(ceili(measured_ms / BUCKET_WIDTH_MS) - 1, 0, BUCKET_COUNT - 1)
	_buckets[bucket_index] += 1


func percentile_ms(quantile: float) -> float:
	if sample_count <= 0:
		return INF
	var rank := clampi(ceili(clampf(quantile, 0.0, 1.0) * float(sample_count)), 1, sample_count)
	var cumulative := 0
	for bucket_index in _buckets.size():
		cumulative += _buckets[bucket_index]
		if cumulative >= rank:
			return minf(worst_ms, float(bucket_index + 1) * BUCKET_WIDTH_MS)
	return worst_ms


func average_hz() -> float:
	return 1000.0 * float(sample_count) / sum_ms if sum_ms > 0.0 else 0.0


func bucket_count() -> int:
	return _buckets.size()


func evidence_snapshot() -> Dictionary:
	return {
		"method": "fixed-memory nearest-rank histogram with conservative bucket upper bounds",
		"bucket_width_ms": BUCKET_WIDTH_MS,
		"max_bucketed_ms": MAX_BUCKETED_MS,
		"bucket_count": _buckets.size(),
		"sample_count": sample_count,
		"sum_ms": sum_ms,
		"worst_ms": worst_ms,
		"overflow_count": overflow_count,
	}
