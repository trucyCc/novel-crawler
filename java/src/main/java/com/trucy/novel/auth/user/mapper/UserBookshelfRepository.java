package com.trucy.novel.auth.user.mapper;

import com.trucy.novel.auth.user.mapper.po.UserBookshelf;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserBookshelfRepository extends JpaRepository<UserBookshelf, Integer> {
}