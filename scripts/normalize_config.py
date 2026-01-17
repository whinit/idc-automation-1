#!/usr/bin/env python3
import re
from pathlib import Path

# 민감/노이즈 라인 정규화 규칙 (필요하면 여기만 튜닝)
MASK_RULES = [
    # EOS/ASA 공통: password/secret/key 류는 값 마스킹
    (re.compile(r"^(.*\b(password|passwd|secret|key|community)\b\s+).*$", re.IGNORECASE), r"\1<REDACTED>"),
    # EOS: last change 같은 코멘트(환경별로 있을 수 있음)
    (re.compile(r"^!+\s*Last configuration change.*$", re.IGNORECASE), ""),
    (re.compile(r"^!+\s*Time:.*$", re.IGNORECASE), ""),
    # ASA: crypto cert 블록이 있으면 통째로 노이즈가 될 수 있어(필요시 활성화)
    # (re.compile(r"^crypto ca certificate.*$", re.IGNORECASE), "<CERT_BLOCK_REDACTED>"),
]

# 완전히 버릴 라인 패턴(필요하면 추가)
DROP_LINE_PATTERNS = [
    re.compile(r"^\s*$"),                 # 빈 줄
    re.compile(r"^!+\s*$"),               # '!' 만 있는 줄
]

def normalize_text(text: str) -> str:
    out_lines = []
    for raw in text.splitlines():
        line = raw.rstrip()

        # 드랍 패턴
        if any(p.match(line) for p in DROP_LINE_PATTERNS):
            continue

        # 마스킹/치환 규칙
        for pat, repl in MASK_RULES:
            if pat.match(line):
                line = pat.sub(repl, line)
                break

        if line == "":
            continue

        out_lines.append(line)

    # 끝에 개행 한 번 보장
    return "\n".join(out_lines) + "\n"

def normalize_dir(src_dir: Path, dst_dir: Path) -> int:
    dst_dir.mkdir(parents=True, exist_ok=True)
    count = 0
    for f in sorted(src_dir.glob("*.cfg")):
        dst = dst_dir / f.name
        text = f.read_text(errors="ignore")
        norm = normalize_text(text)
        dst.write_text(norm)
        count += 1
    return count

def main():
    root = Path(__file__).resolve().parents[1]
    backups = root / "artifacts" / "backups"
    normalized = root / "artifacts" / "normalized"

    total = 0
    for dev in ("eos", "asa"):
        src = backups / dev
        dst = normalized / dev
        if src.exists():
            total += normalize_dir(src, dst)

    print(f"OK: normalized {total} file(s) into artifacts/normalized/*")

if __name__ == "__main__":
    main()
