<template>
  <view class="profile-page">
    <!-- 自定义导航栏 -->
    <view class="nav-bar">
      <text class="fas fa-arrow-left back-btn" @click="goBack"></text>
      <text class="nav-title">个人中心</text>
      <view class="placeholder"></view>
    </view>

    <!-- 用户信息卡片 -->
    <view class="user-card">
      <view class="avatar">
        <text class="fas fa-user-circle"></text>
      </view>
      <view class="user-info">
        <text class="user-name">李阿姨</text>
        <text class="user-phone">138****1234</text>
      </view>
    </view>

    <!-- 添加老人按钮（放在列表上方） -->
    <view class="add-section">
      <button class="add-btn" @click="showBindPopup = true">
        <text class="fas fa-user-plus"></text>
        <text>添加老人</text>
      </button>
    </view>

    <!-- 绑定的老人列表 -->
    <view class="section-title">
      <text class="fas fa-heart"></text>
      <text>我守护的老人</text>
    </view>

    <view class="elderly-list">
      <view v-for="(item, index) in elderlyList" :key="index" class="elderly-item">
        <view class="elderly-info">
          <text class="elderly-name">{{ item.name }}</text>
          <text class="elderly-relation">{{ item.relation }}</text>
        </view>
        <button class="unbind-btn" @click="confirmUnbind(item)">取消关联</button>
      </view>
      <view v-if="elderlyList.length === 0" class="empty-tip">
        暂无绑定的老人，快去添加吧
      </view>
    </view>

    <!-- 退出登录按钮 -->
    <button class="logout-btn" @click="logout">退出登录</button>

    <!-- 绑定弹窗 -->
    <view v-if="showBindPopup" class="popup-overlay" @click="showBindPopup = false">
      <view class="popup-content" @click.stop>
        <text class="popup-title">绑定老人</text>
        <view class="input-area">
          <input
            type="number"
            v-model="inviteCode"
            placeholder="请输入6位邀请码"
            maxlength="6"
            confirm-type="done"
            @confirm="bindElderly"
          />
        </view>
        <button class="popup-btn bind-btn" @click="bindElderly" :disabled="!canBind">确 定</button>
        <button class="popup-btn close-btn" @click="showBindPopup = false">取 消</button>
      </view>
    </view>

    <!-- 确认取消关联弹窗 -->
    <view v-if="showUnbindConfirm" class="popup-overlay" @click="showUnbindConfirm = false">
      <view class="popup-content" @click.stop>
        <text class="popup-title">确认取消关联</text>
        <text class="popup-message">确定要取消与 {{ unbindTarget?.name }} 的关联吗？</text>
        <view class="popup-actions">
          <button class="popup-btn cancel-btn" @click="showUnbindConfirm = false">再想想</button>
          <button class="popup-btn confirm-btn" @click="unbind">确 定</button>
        </view>
      </view>
    </view>

    <!-- Toast提示 -->
    <view v-if="toastVisible" class="toast">{{ toastMessage }}</view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      elderlyList: [
        { id: 1, name: '张爷爷', relation: '父亲' },
        { id: 2, name: '王奶奶', relation: '母亲' }
      ],
      showUnbindConfirm: false,
      unbindTarget: null,
      toastVisible: false,
      toastMessage: '',
      // 绑定弹窗相关
      showBindPopup: false,
      inviteCode: ''
    };
  },
  computed: {
    canBind() {
      return this.inviteCode.length === 6;
    }
  },
  methods: {
    goBack() {
      uni.navigateBack();
    },
    showToast(msg) {
      this.toastMessage = msg;
      this.toastVisible = true;
      setTimeout(() => {
        this.toastVisible = false;
      }, 2000);
      if (navigator.vibrate) navigator.vibrate(30);
    },
    confirmUnbind(item) {
      this.unbindTarget = item;
      this.showUnbindConfirm = true;
    },
    unbind() {
      if (!this.unbindTarget) return;
      uni.showLoading({ title: '处理中...' });
      setTimeout(() => {
        uni.hideLoading();
        this.elderlyList = this.elderlyList.filter(item => item.id !== this.unbindTarget.id);
        this.showUnbindConfirm = false;
        this.unbindTarget = null;
        this.showToast('已取消关联');
        uni.$emit('refreshElderlyList'); // 通知首页刷新
      }, 800);
    },
    logout() {
      uni.showModal({
        title: '提示',
        content: '确定要退出登录吗？',
        success: (res) => {
          if (res.confirm) {
            uni.reLaunch({
              url: '/pages/login/login'
            });
          }
        }
      });
    },
    bindElderly() {
      if (!this.canBind) return;
      uni.showLoading({ title: '绑定中...' });
      setTimeout(() => {
        uni.hideLoading();
        this.showToast('绑定成功');
        this.showBindPopup = false;
        this.inviteCode = '';
        uni.$emit('refreshElderlyList'); // 通知首页刷新
      }, 1000);
    }
  }
};
</script>

<style scoped>
.profile-page {
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

.user-card {
  background-color: white;
  margin: 0 30rpx 30rpx;
  padding: 40rpx;
  border-radius: 40rpx;
  display: flex;
  align-items: center;
  gap: 30rpx;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05);
}
.avatar {
  font-size: 120rpx;
  color: #2b7fff;
}
.user-info {
  display: flex;
  flex-direction: column;
}
.user-name {
  font-size: 48rpx;
  font-weight: bold;
  margin-bottom: 10rpx;
}
.user-phone {
  font-size: 32rpx;
  color: #6b7280;
}

.add-section {
  margin: 0 30rpx 30rpx;
}
.add-btn {
  background-color: #10b981;
  border: none;
  border-radius: 60rpx;
  padding: 30rpx;
  color: white;
  font-size: 40rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 15rpx;
  box-shadow: 0 6rpx 12rpx rgba(16, 185, 129, 0.3);
}
.add-btn:active {
  transform: scale(0.96);
  background-color: #0d9f6e;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 15rpx;
  margin: 30rpx 30rpx 20rpx;
  font-size: 40rpx;
  font-weight: bold;
  color: #1e2b3c;
}
.section-title .fas {
  color: #ef4444;
}

.elderly-list {
  background-color: white;
  margin: 0 30rpx;
  border-radius: 40rpx;
  padding: 20rpx;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05);
}
.elderly-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 30rpx;
  border-bottom: 2rpx solid #f3f4f6;
}
.elderly-item:last-child {
  border-bottom: none;
}
.elderly-info {
  display: flex;
  flex-direction: column;
}
.elderly-name {
  font-size: 40rpx;
  font-weight: 500;
  margin-bottom: 6rpx;
}
.elderly-relation {
  font-size: 32rpx;
  color: #6b7280;
}
.unbind-btn {
  background-color: #fee2e2;
  color: #ef4444;
  border: none;
  border-radius: 60rpx;
  padding: 16rpx 40rpx;
  font-size: 32rpx;
  font-weight: 500;
}
.unbind-btn:active {
  background-color: #fecaca;
  transform: scale(0.96);
}

.empty-tip {
  text-align: center;
  padding: 60rpx;
  color: #9ca3af;
  font-size: 36rpx;
}

.logout-btn {
  background-color: white;
  border: 2rpx solid #ef4444;
  color: #ef4444;
  border-radius: 60rpx;
  padding: 30rpx;
  margin: 60rpx 30rpx 30rpx;
  font-size: 40rpx;
  font-weight: 500;
}
.logout-btn:active {
  background-color: #fee2e2;
}

/* 弹窗样式 */
.popup-overlay {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background-color: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}
.popup-content {
  background-color: white;
  border-radius: 40rpx;
  padding: 50rpx 40rpx;
  width: 80%;
  max-width: 600rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 30rpx;
}
.popup-title {
  font-size: 48rpx;
  font-weight: bold;
  color: #1e2b3c;
}
.popup-message {
  font-size: 36rpx;
  color: #374151;
  text-align: center;
}
.popup-actions {
  display: flex;
  gap: 30rpx;
  width: 100%;
}
.popup-btn {
  flex: 1;
  height: 90rpx;
  border-radius: 45rpx;
  font-size: 36rpx;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: center;
}
.cancel-btn {
  background-color: #e5e7eb;
  color: #374151;
}
.confirm-btn {
  background-color: #ef4444;
  color: white;
  border: none;
}
.confirm-btn:active {
  background-color: #dc2626;
  transform: scale(0.96);
}
.cancel-btn:active {
  background-color: #d1d5db;
}

.input-area {
  width: 100%;
}
.input-area input {
  width: 100%;
  height: 100rpx;
  background-color: #f8faff;
  border: 2rpx solid #d9e2ef;
  border-radius: 30rpx;
  font-size: 48rpx;
  text-align: center;
  letter-spacing: 10rpx;
  padding: 0 20rpx;
}
.bind-btn {
  background-color: #2b7fff;
  color: white;
  border: none;
}
.bind-btn:active {
  background-color: #1a5fd0;
  transform: scale(0.96);
}
.bind-btn[disabled] {
  opacity: 0.5;
  pointer-events: none;
}
.close-btn {
  background-color: #e5e7eb;
  color: #374151;
}
.close-btn:active {
  background-color: #d1d5db;
}

.toast {
  position: fixed;
  top: 50rpx;
  left: 50%;
  transform: translateX(-50%);
  background-color: rgba(0,0,0,0.8);
  color: white;
  padding: 20rpx 60rpx;
  border-radius: 60rpx;
  font-size: 32rpx;
  z-index: 1000;
}
</style>