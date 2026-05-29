package com.cartiva.dao;

import java.util.List;
import com.cartiva.model.User;

public interface UserDAO {

    boolean registerUser(User user);

    User loginUser(String email, String password);

    User getUserById(int userId);

    User getUserByEmail(String email);


    User getUserByPhone(String phone);

    boolean updateUser(User user);

    boolean updatePassword(int userId, String newPassword);
    boolean updatePasswordByEmail(String email, String newPassword);

    boolean emailExists(String email);

    boolean phoneExists(String phone);

    List<User> getAllUsers();
}