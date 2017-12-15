package com.cn.hnust.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.cn.hnust.dao.IUserDao;
import com.cn.hnust.pojo.User;
import com.cn.hnust.service.IUserService;

@Service("userService")
public class UserServiceImpl implements IUserService {
	@Resource
	private IUserDao userDao;
	public List<Map<String, Object>> getUser(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return userDao.selectByPrimaryKey(map);
	}
	public long insert(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return userDao.insertSelective(map);
	}
	public long update(Map<String, Object> map) {
		// TODO Auto-generated method stub
		 return userDao.updateByPrimaryKeySelective(map);
	}
	public long delete(Integer id) {
		// TODO Auto-generated method stub
		 return userDao.deleteByPrimaryKey(id);
	}

}
