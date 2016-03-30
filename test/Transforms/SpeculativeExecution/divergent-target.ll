; RUN: opt < %s -S -speculative-execution | FileCheck --check-prefix=ON %s
; RUN: opt < %s -S -speculative-execution -spec-exec-only-if-divergent-target | \
; RUN:   FileCheck --check-prefix=ON %s
; RUN: opt < %s -S -march=x86_64 -speculative-execution -spec-exec-only-if-divergent-target | \
; RUN:   FileCheck --check-prefix=OFF %s

target triple = "nvptx-nvidia-cuda"

; Hoist in if-then pattern.
define void @f() {
; CHECK-LABEL: @ifThen(
; ON: %x = add i32 2, 3
; ON: br i1 true
; OFF: br i1 true
; OFF: %x = add i32 2, 3
  br i1 true, label %a, label %b
a:
  %x = add i32 2, 3
  br label %b
b:
  ret void
}
