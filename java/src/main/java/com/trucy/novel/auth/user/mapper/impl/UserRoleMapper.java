package com.trucy.novel.auth.user.mapper.impl;

import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@AllArgsConstructor
public class UserRoleMapper {
    private JPAQueryFactory jpaQueryFactory;

}
