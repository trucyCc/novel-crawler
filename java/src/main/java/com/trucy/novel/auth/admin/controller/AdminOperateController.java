package com.trucy.novel.auth.admin.controller;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@Tag(name = "管理员操作")
@RestController
@AllArgsConstructor
@CrossOrigin(origins = "*")
@RequestMapping("/admin/operate")
public class AdminOperateController {
}
