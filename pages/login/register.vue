<template>
  <view class="register-container">
    <view class="register-card">
      <!-- 返回按钮（自定义） -->
      <view class="back-btn" @click="goBack">
        <text class="fas fa-arrow-left"></text>
      </view>

      <!-- 标题 -->
      <view class="brand">
        <view class="brand-icon">
          <text class="fas fa-user-plus"></text>
        </view>
        <text class="brand-title">注册新账号</text>
        <text class="brand-sub">请填写以下信息</text>
      </view>

      <!-- 角色选择 -->
      <view class="role-selector">
        <view 
          class="role-option" 
          :class="{ active: registerRole === 'elderly' }"
          @click="registerRole = 'elderly'"
        >
          <text class="fas fa-user"></text>
          <text>老人端</text>
        </view>
        <view 
          class="role-option" 
          :class="{ active: registerRole === 'family' }"
          @click="registerRole = 'family'"
        >
          <text class="fas fa-users"></text>
          <text>家属端</text>
        </view>
      </view>

      <!-- 手机号 -->
      <view class="input-group">
        <text class="input-label">手机号</text>
        <view class="input-field">
          <text class="fas fa-phone-alt"></text>
          <input
            type="tel"
            v-model="phone"
            placeholder="请输入手机号"
            placeholder-class="placeholder"
          />
        </view>
      </view>

      <!-- 密码 -->
      <view class="input-group">
        <text class="input-label">密码</text>
        <view class="input-field">
          <text class="fas fa-lock"></text>
          <input
            type="password"
            v-model="password"
            placeholder="6-20位密码"
            placeholder-class="placeholder"
          />
        </view>
      </view>

      <!-- 确认密码 -->
      <view class="input-group">
        <text class="input-label">确认密码</text>
        <view class="input-field">
          <text class="fas fa-lock"></text>
          <input
            type="password"
            v-model="confirmPwd"
            placeholder="再次输入密码"
            placeholder-class="placeholder"
          />
        </view>
      </view>

      <!-- 注册按钮 -->
      <button class="register-btn" @click="handleRegister">
        <text class="fas fa-check-circle"></text>
        <text>注 册</text>
      </button>

      <!-- 已有账号？去登录 -->
      <view class="login-link" @click="goToLogin">
        <text>已有账号？</text>
        <text class="link">立即登录</text>
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
      registerRole: 'elderly',
      phone: '',
      password: '',
      confirmPwd: '',
      toastVisible: false,
      toastMessage: '',
    };
  },
  methods: {
    showToast(msg) {
      this.toastMessage = msg;
      this.toastVisible = true;
      setTimeout(() => {
        this.toastVisible = false;
      }, 2000);
      if (navigator.vibrate) navigator.vibrate(30);
    },
    goBack() {
      uni.navigateBack();
    },
    goToLogin() {
      uni.navigateBack(); // 返回登录页，或者直接跳转
    },
    handleRegister() {
      if (!this.phone || !this.password || !this.confirmPwd) {
        this.showToast('请填写完整信息');
        return;
      }
      if (this.password !== this.confirmPwd) {
        this.showToast('两次密码不一致');
        return;
      }
      // 模拟注册成功，跳转到登录页（可带角色参数）
      this.showToast('注册成功，请登录');
      setTimeout(() => {
        uni.navigateTo({
          url: `/pages/login/login?role=${this.registerRole}`
        });
      }, 1500);
    }
  }
};
</script>

<style scoped>
.register-container {
  min-height: 100vh;
  background-color: #f0f2f5;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 30rpx;
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
}

.register-card {
  width: 100%;
  max-width: 650rpx;
  background-color: white;
  border-radius: 60rpx;
  padding: 60rpx 40rpx;
  box-shadow: 0 20rpx 50rpx rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  gap: 40rpx;
  position: relative;
}

.back-btn {
  position: absolute;
  top: 30rpx;
  left: 30rpx;
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  background-color: #f0f4fa;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40rpx;
  color: #2b7fff;
}

.brand {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20rpx;
  margin-top: 30rpx;
  margin-bottom: 10rpx;
}
.brand-icon {
  width: 140rpx;
  height: 140rpx;
  background: linear-gradient(145deg, #10b981, #059669);
  border-radius: 40rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 70rpx;
  box-shadow: 0 10rpx 20rpx rgba(5, 150, 105, 0.3);
}
.brand-title {
  font-size: 48rpx;
  font-weight: bold;
  color: #1e2b3c;
}
.brand-sub {
  font-size: 32rpx;
  color: #5e6f8d;
}

.role-selector {
  display: flex;
  gap: 30rpx;
  justify-content: center;
}
.role-option {
  flex: 1;
  background-color: #f0f4fa;
  border-radius: 30rpx;
  padding: 30rpx 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10rpx;
  border: 4rpx solid transparent;
  transition: all 0.2s;
  font-size: 32rpx;
  color: #3a4a5e;
}
.role-option text:first-child {
  font-size: 48rpx;
}
.role-option.active {
  background-color: #e6f0ff;
  border-color: #10b981;
  color: #10b981;
  font-weight: bold;
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}
.input-label {
  font-size: 32rpx;
  font-weight: 500;
  color: #2c3e50;
  margin-left: 10rpx;
}
.input-field {
  display: flex;
  align-items: center;
  background-color: #f8faff;
  border: 2rpx solid #d9e2ef;
  border-radius: 30rpx;
  padding: 0 30rpx;
  transition: all 0.2s;
}
.input-field:focus-within {
  border-color: #10b981;
  box-shadow: 0 0 0 6rpx rgba(16, 185, 129, 0.2);
  background-color: white;
}
.input-field text {
  font-size: 36rpx;
  color: #7b8cae;
  width: 60rpx;
  text-align: center;
}
.input-field input {
  flex: 1;
  height: 100rpx;
  font-size: 36rpx;
  background: transparent;
  border: none;
  padding-left: 20rpx;
}
.placeholder {
  color: #a6b8d0;
  font-size: 32rpx;
}

.register-btn {
  background-color: #10b981;
  border: none;
  border-radius: 50rpx;
  height: 120rpx;
  color: white;
  font-size: 40rpx;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20rpx;
  margin-top: 20rpx;
  box-shadow: 0 12rpx 30rpx rgba(16, 185, 129, 0.4);
  transition: transform 0.1s;
}
.register-btn:active {
  transform: scale(0.96);
  background-color: #0d9f6e;
}
.register-btn text:first-child {
  font-size: 44rpx;
}

.login-link {
  text-align: center;
  font-size: 32rpx;
  color: #6f7d98;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10rpx;
  margin-top: 20rpx;
}
.login-link .link {
  color: #10b981;
  font-weight: 500;
  text-decoration: underline;
  text-underline-offset: 4rpx;
}

.toast {
  position: fixed;
  bottom: 100rpx;
  left: 50%;
  transform: translateX(-50%);
  background-color: #1e2b3c;
  color: white;
  padding: 20rpx 60rpx;
  border-radius: 60rpx;
  font-size: 32rpx;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.3);
  z-index: 999;
}
</style>