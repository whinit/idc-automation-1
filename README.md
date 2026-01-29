# IDC Network Automation & Monitoring Lab

## 개요
본 프로젝트는 실제 IDC 운영 환경을 가정하여  
네트워크 장비 설정 변경(Config Drift)을 자동으로 감지하고  
운영 중 장애 리스크를 사전에 예방하기 위한 운영 자동화 실습 프로젝트입니다.

Ansible과 Python을 활용해 Cisco ASA, Arista EOS 환경에서  
설정 백업 → 정규화 → Diff 비교 → 리포트 생성 → Slack 알림까지  
운영 흐름을 자동화했습니다.

## 목적
- 네트워크 설정 변경(Config Drift) 자동 감지
- 의도되지 않은 변경으로 인한 장애 사전 예방
- 수동 점검 자동화를 통한 운영 리스크 감소

## 자동화 흐름
Config Backup → Normalize → Diff → Report → Slack Alert


## 구성 요소
- **Network**: Cisco ASA, Arista EOS
- **Automation**: Ansible (backup, diff), Python/Shell
- **Artifacts**: 정규화된 설정 파일, Drift 리포트

## 디렉토리 구조

```text
ansible/
 ├─ hosts.yml
 ├─ asa_precheck.yml
 ├─ backup_only.yml
 └─ group_vars/
     ├─ asa/
     │   └─ main.yml
     └─ eos/
         └─ main.yml

artifacts/
 ├─ normalized/
 │   ├─ asa/
 │   └─ eos/
 └─ reports/
     └─ drift/

scripts/
 ├─ normalize_config.py
 ├─ drift_report.sh
 ├─ notify_slack.sh
 └─ run_nightly_drift.sh

## 핵심 구현
- 멀티벤더 설정 정규화(normalization) 후 Diff 비교
- 실행 시점별 Drift 리포트 자동 생성
- 설정 변경 발생 시 Slack 알림 연계
- 야간 운영을 가정한 정기 자동 실행
