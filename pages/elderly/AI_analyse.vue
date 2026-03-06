<template>
  <view class="diagnose-page">
    <!-- 自定义导航栏 -->
    <view class="nav-bar">
      <text class="fas fa-arrow-left back-btn" @click="goBack"></text>
      <text class="nav-title">AI 健康分析</text>
      <view class="placeholder"></view>
    </view>

    <!-- 人脸扫描步骤 -->
    <view v-if="step === 'scan'" class="scan-section">
      <view class="scan-card">
        <view class="camera-placeholder">
          <text class="fas fa-camera"></text>
        </view>
        <text class="scan-tip">请将面部对准摄像头，保持光线充足</text>
        <button class="scan-btn" @click="startScan">
          <text class="fas fa-camera-retro"></text>
          <text>开始扫描</text>
        </button>
      </view>
    </view>

    <!-- 结果显示步骤 -->
    <view v-else class="result-section">
      <!-- 体质报告卡片 -->
      <view class="result-card">
        <text class="result-title"><text class="fas fa-flask"></text> 体质分析报告</text>
        <view class="constitution-box">
          <text class="constitution-type">{{ report.constitution }}</text>
          <text class="constitution-score">得分 {{ report.score }}</text>
        </view>
        <view class="desc-text">{{ report.description }}</view>
      </view>

      <!-- 食谱建议卡片 -->
      <view class="result-card">
        <text class="result-title"><text class="fas fa-utensils"></text> 今日饮食建议</text>
        <view class="food-list">
          <view v-for="(item, index) in report.foods" :key="index" class="food-item">
            <text class="food-name">{{ item.name }}</text>
            <text class="food-reason">{{ item.reason }}</text>
          </view>
        </view>
      </view>

      <!-- 健康小贴士 -->
      <view class="tip-card">
        <text class="fas fa-info-circle"></text>
        <text class="tip-text">本分析结果由 AI 生成，仅供参考，不作为医疗诊断依据。</text>
      </view>

      <button class="restart-btn" @click="restart">
        <text class="fas fa-redo-alt"></text>
        <text>重新分析</text>
      </button>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      step: 'scan', // 'scan' 或 'result'
      report: {
        constitution: '平和质',
        score: 92,
        description: '阴阳平衡，气血调和，身体状态良好。建议保持规律作息，适当运动。',
        foods: [
          { name: '山药', reason: '健脾益气' },
          { name: '红枣', reason: '补血养颜' },
          { name: '小米', reason: '养胃安神' }
        ]
      }
    };
  },
  methods: {
    goBack() {
      uni.navigateBack();
    },
    startScan() {
      uni.showLoading({ title: '分析中...' });
      setTimeout(() => {
        uni.hideLoading();
        this.step = 'result';
      }, 2000);
    },
    restart() {
      this.step = 'scan';
    }
  }
};
</script>

<style scoped>
.diagnose-page {
  min-height: 100vh;
  background-color: #f3f4f6;
  font-family: 'PingFang SC', sans-serif;
  padding-bottom: 60rpx;
}

.nav-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 30rpx 30rpx 20rpx;
  background-color: white;
}
.back-btn {
  font-size: 48rpx;
  color: #2b7fff;
  padding: 20rpx;
}
.nav-title {
  font-size: 40rpx;
  font-weight: bold;
  color: #1e2b3c;
}
.placeholder {
  width: 88rpx;
}

/* 扫描步骤 */
.scan-section {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 60rpx 30rpx;
}
.scan-card {
  background-color: white;
  border-radius: 60rpx;
  padding: 80rpx 40rpx;
  width: 100%;
  max-width: 600rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 40rpx;
  box-shadow: 0 20rpx 40rpx rgba(0,0,0,0.1);
}
.camera-placeholder {
  width: 300rpx;
  height: 300rpx;
  border-radius: 50%;
  background-color: #f0f4fa;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 120rpx;
  color: #2b7fff;
}
.scan-tip {
  font-size: 36rpx;
  color: #374151;
  text-align: center;
}
.scan-btn {
  background-color: #2b7fff;
  color: white;
  border: none;
  border-radius: 60rpx;
  padding: 30rpx 80rpx;
  font-size: 40rpx;
  display: flex;
  align-items: center;
  gap: 20rpx;
}
.scan-btn:active {
  transform: scale(0.96);
  background-color: #1a5fd0;
}

/* 结果步骤 */
.result-section {
  padding: 30rpx;
  display: flex;
  flex-direction: column;
  gap: 30rpx;
}
.result-card {
  background-color: white;
  border-radius: 40rpx;
  padding: 40rpx;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05);
}
.result-title {
  font-size: 40rpx;
  font-weight: bold;
  color: #1e2b3c;
  display: block;
  margin-bottom: 30rpx;
}
.result-title .fas {
  color: #10b981;
  margin-right: 10rpx;
}
.constitution-box {
  display: flex;
  align-items: baseline;
  gap: 20rpx;
  margin-bottom: 20rpx;
}
.constitution-type {
  font-size: 80rpx;
  font-weight: bold;
  color: #2b7fff;
}
.constitution-score {
  font-size: 40rpx;
  color: #6b7280;
}
.desc-text {
  font-size: 36rpx;
  color: #374151;
  line-height: 1.6;
}
.food-list {
  display: flex;
  flex-direction: column;
  gap: 30rpx;
}
.food-item {
  border-bottom: 2rpx solid #f3f4f6;
  padding-bottom: 20rpx;
}
.food-name {
  font-size: 40rpx;
  font-weight: 500;
  display: block;
  margin-bottom: 10rpx;
}
.food-reason {
  font-size: 32rpx;
  color: #6b7280;
}
.tip-card {
  background-color: #fef9e7;
  border-left: 8rpx solid #fbbf24;
  padding: 30rpx;
  border-radius: 30rpx;
  display: flex;
  align-items: center;
  gap: 20rpx;
}
.tip-card .fas {
  font-size: 48rpx;
  color: #fbbf24;
}
.tip-text {
  font-size: 32rpx;
  color: #92400e;
  flex: 1;
}
.restart-btn {
  background-color: white;
  border: 2rpx solid #2b7fff;
  color: #2b7fff;
  border-radius: 60rpx;
  padding: 30rpx;
  font-size: 40rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20rpx;
  margin-top: 20rpx;
}
.restart-btn:active {
  background-color: #f0f7ff;
}
</style>