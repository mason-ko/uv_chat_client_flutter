#!/bin/bash

# 프로젝트의 루트 디렉터리에서 실행하세요

# lib 폴더 안에 필요한 폴더와 파일 생성
mkdir -p lib/screens lib/models lib/services

# main.dart 파일 생성
touch lib/main.dart

# screens 폴더 내 파일 생성
touch lib/screens/login_screen.dart
touch lib/screens/home_screen.dart
touch lib/screens/chat_list_screen.dart
touch lib/screens/message_screen.dart

# models 폴더 내 파일 생성
touch lib/models/channel.dart
touch lib/models/message.dart

# services 폴더 내 파일 생성
touch lib/services/auth_service.dart
touch lib/services/chat_service.dart
touch lib/services/user_service.dart

echo "폴더와 파일이 성공적으로 생성되었습니다!"

