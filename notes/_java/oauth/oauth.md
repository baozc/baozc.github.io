## client credentials
http -v post :9000/oauth/token Authorization:"Basic Y2xpZW50XzE6MTIzNDU2" grant_type==client_credentials

### access_token
http :9000/api/user/me name==user access_token==6cc3932a-429e-4419-8d75-e3f65f891c6e

http -v --form post :9000/oauth/token grant_type=password username=test password=123456 client_id=client_2 client_secret=123456

#### 密码校验
client密码默认取{id}，怎么更改获取加密方式的？
用户密码没有这个限制
dfjx authorization用的是继承重写加密

#### 获取token方式
?access_token拼接
header头
表单
怎么应用的  OAuth2AuthenticationProcessingFilter - tokenExtractor.extract

SecurityContextHolder.getContext().setAuthentication(authResult);

带token验证时，会设置details，设置完成后会执行这个filter，重新设置authentication，导致details为空
AuthSecurityContextFilter
 Authentication auth = SecurityContextHolder.getContext().getAuthentication();
 SecurityContextHolder.getContext().setAuthentication(newAuth);

#### dfjx authorization
http -vf :8089/oauth/token grant_type=password client_id=testclientid client_secret=123456 username=admin password=123456

FilterChainProxy
AbstractAuthenticationProcessingFilter

#### 客户端认证，加token
http -v get :8001/dcMsg/query Authorization:'Bearer 48f8e8a4-5320-44f8-83fc-470863ce32ce'  msgType=1
http -v get :8001/dcMsg/query access_token=48f8e8a4-5320-44f8-83fc-470863ce32ce  msgType=1

## 
