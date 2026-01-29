# IDC Network Automation & Monitoring Lab

본 프로젝트는 **실제 IDC 환경을 가정하여**
네트워크 설정 변경 감지(Config Drift),
알림, 자동화 운영을 구현한 개인 실습 프로젝트입니다.

Ansible과 Python을 활용해
멀티벤더 네트워크 장비를 대상으로
운영 안정성을 높이는 자동화 흐름을 설계·검증했습니다.

---

## 🎯 프로젝트 목적

- 네트워크 설정 변경(Drift) 자동 감지
- 운영 중 설정 차이로 인한 장애 사전 예방
- 수동 점검을 자동화하여 운영 리스크 감소

---

## 🏗️ 구성 환경

- **Network Devices**
  - Cisco ASA
  - Arista EOS

- **Automation**
  - Ansible (Config backup / Diff / Alert)
  - Python (스크립트 기반 보조 자동화)

- **Monitoring & Alert**
  - Config Drift Detection
  - 변경 발생 시 알림 자동화

---

## 📂 디렉터리 구조

```text
.
├── ansible/        # Ansible playbooks & inventory
├── scripts/        # Python / Shell automation scripts
├── artifacts/      # Config backup & diff 결과물
├── ansible.cfg
└── .gitignore

> 본 프로젝트는 단순 자동화 구현이 아닌,
> 실제 운영 환경에서 발생 가능한 장애 시나리오를 기준으로
> 자동화 설계와 검증에 초점을 맞췄습니다.

