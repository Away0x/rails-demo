class AccountsController < ApplicationController

  def login
  end

  def signup
    @account = Account.new
  end

  def create_account
    #取出哈希param中的name、email等元素
    name = params[:account][:name]
    email = params[:account][:email]
    password = params[:account][:password]
    password_confirmation = params[:account][:password_confirmation]
    role = params[:account][:role]
    #status为0，代表账号是激活状态；为1，代表账号是未激活状态
    #role角色 0普通用户 1管理员 2超级管理员
    #角色为管理员的时候(即role等于1)，账号要被设为未激活状态(即status等于1)
    #其他角色注册账号，状态默认为激活状态
    status = 0
    if role.to_i == 1
      status = 1
    end

    #从账户表中查找是否有相同的email，有相同的email说明该邮箱已经被注册过了
    account = Account.find_by(email:email)
    #创建一个Account类的对象
    @account = Account.new
    #先判断name、email是否为空
    if name.blank? || email.blank?
      flash.notice = "用户名或者邮箱不能为空"
      render :signup
    #判断account是否存在，即是否存在相同邮箱的用户
    elsif account
      flash.notice = "邮箱已注册"
      render :signup
    #判断名字的长度是否大于5
    elsif name.length > 5
      flash.notice = "用户名长度不能大于5"
      render :signup
    #判断密码和确认密码是否一致
    elsif password != password_confirmation
      flash.notice = "两次密码输入不一致"
      render :signup
    #上面条件全部不符合，会进入else语句，将填写的信息保存到数据中
    else
      @account.status = status
      @account.name = name
      @account.email = email
      @account.password = Des.des_encode(password)
      @account.role = role
      #.save保存成功时，返回true，失败时返回false
      boolean = @account.save
      #boolean为true时说明account保存成功
      if boolean
        flash.notice = "注册成功！请登录"
        redirect_to :login #注册成功，将页面重定向到登录页面
      else
        flash.notice = "注册失败！请重新注册"
        render :signup
      end
    end
  end

end
