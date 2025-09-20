from paraview.simple import *

# 加载数据
data = OpenDataFile("hs4_out_sub_app0.e")

# 创建 Probe Location
probe = ProbeLocation(Input=data)
probe.ProbeType.Center = [0, 0, 0]  # 替换为目标点的坐标
# 更新并获取结果
UpdatePipeline(probe)
result = servermanager.Fetch(probe)
print(result.GetPointData().GetArray("P").GetValue(0))  # 替换 "Pressure" 为你的压力字段名称
