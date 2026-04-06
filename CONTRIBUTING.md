# Contributing to Kulfi

## 브랜치 전략

### 브랜치 구조

```
main
 └── dev
      └── feat/기능명
      └── fix/버그명
      └── refactor/리팩토링명
      └── ...
hotfix/긴급수정명 (main에서 직접 생성)
```

### 브랜치 네이밍 규칙

이슈가 있는 경우 이슈 번호를 포함합니다.

```
# 이슈가 있는 경우
feat/24-user-auth
fix/31-login-redirect
perf/24-image-optimization
refactor/53-kopis-sync-improvements

# 이슈가 없는 경우
feat/user-auth
docs/api-guide
chore/gradle-update
```

### 브랜치 운용 규칙

| 브랜치 | 설명 | 직접 Push |
|--------|------|-----------|
| `main` | 프로덕션 배포 브랜치 | ❌ 금지 |
| `dev` | 개발 통합 브랜치 | ❌ 금지 |
| `feat/*` 등 | 기능 단위 작업 브랜치 | ✅ 허용 |
| `hotfix/*` | 프로덕션 긴급 수정 브랜치 | ✅ 허용 |

---

## PR 규칙

### feature → dev

- Self-merge 허용
- **Claude Code 리뷰 필수** (머지 전 리뷰 완료 확인)
- PR 템플릿 항목 성실히 작성

### dev → main

- 리뷰 없이 머지 가능
- 배포 전 로컬 테스트 완료 확인

### hotfix 흐름

프로덕션 버그 발견 시 아래 순서를 따릅니다.

```bash
# 1. main에서 hotfix 브랜치 생성
git checkout main
git checkout -b hotfix/결제-오류-수정

# 2. 버그 수정 후 main에 머지 (배포)
git checkout main
git merge hotfix/결제-오류-수정

# 3. dev에도 반드시 백머지 (동기화 필수)
git checkout dev
git merge hotfix/결제-오류-수정

# 4. hotfix 브랜치 삭제
git branch -d hotfix/결제-오류-수정
```

> ⚠️ dev 백머지를 생략하면 이후 dev → main 배포 시 수정 사항이 덮어씌워질 수 있습니다.

---

## 커밋 컨벤션

[Conventional Commits](https://www.conventionalcommits.org/) 표준을 따릅니다.

### 형식

```
타입: 변경 내용 요약

(선택) 본문 - 변경 이유나 상세 설명

(선택) 푸터 - 관련 이슈 참조
Resolves: #24
```

### 커밋 타입

| 타입 | 설명 |
|------|------|
| `feat` | 새 기능 추가 |
| `fix` | 버그 수정 |
| `refactor` | 기능 변경 없는 코드 개선 |
| `perf` | 성능 개선 |
| `style` | 포맷, 세미콜론 등 로직과 무관한 변경 |
| `test` | 테스트 코드 추가 및 수정 |
| `docs` | 문서 추가 및 수정 |
| `chore` | 빌드, 패키지 설정 등 기타 변경 |
| `hotfix` | 프로덕션 긴급 버그 수정 |

### 예시

```
feat: 소셜 로그인 구현 (Google, Kakao)

fix: 로그인 후 리다이렉트 경로 오류 수정
Resolves: #31

refactor: UserService 단일 책임 원칙에 맞게 분리
Resolves: #53

perf: 이미지 WebP 변환 및 썸네일 캐싱 적용
Resolves: #24

chore: Gradle 의존성 버전 업데이트

hotfix: 결제 금액 계산 오류 수정
```
