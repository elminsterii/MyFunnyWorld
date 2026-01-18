extends CanvasLayer

# 接收端現在多了一個 accel 參數
func _on_stats_updated(dist: float, height: float, speed: float) -> void:
	$DistanceLabel.text = "距離: %d m" % dist
	$HeightLabel.text = "高度: %d m" % height
	$SpeedLabel.text = "速度: %d km/h" % speed
	#$AccelLabel.text = "加速度: %.1f m/s²" % accel
