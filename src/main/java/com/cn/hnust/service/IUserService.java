package com.cn.hnust.service;

import java.util.List;
import java.util.Map;

import com.cn.hnust.pojo.User;

public interface IUserService {

	public List<Map<String, Object>> getUser(Map<String, Object> map);

	public long insert(Map<String, Object> map);

	public long update(Map<String, Object> map);

	public long delete(Integer id);
}
