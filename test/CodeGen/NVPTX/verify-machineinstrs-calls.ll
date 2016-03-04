; RUN: llc < %s -march=nvptx -mcpu=sm_20 -verify-machineinstrs
; RUN: llc < %s -march=nvptx64 -mcpu=sm_20 -verify-machineinstrs

; Check that we use correctly-annotated MIs when compiling various calls and
; returns.  In particular, the memory-location ISD nodes involved here should
; be correctly annotated as only-load or only-store.

define i32 @f1() {
  ret i32 0
}

define <4 x i32> @f2() {
  ret <4 x i32> <i32 0, i32 0, i32 0, i32 0>
}

declare void @f3(i32);
define void @f4() {
  call void @f3(i32 0)
  ret void
}

define <1 x i32> @f5(<1 x i32>, <2 x i32>, <4 x i32>) {
  ret <1 x i32> <i32 0>
}
define <2 x i32> @f5a() {
  ret <2 x i32> <i32 0, i32 0>
}
define <4 x i32> @f5b() {
  ret <4 x i32> <i32 0, i32 0, i32 0, i32 0>
}
define void @f6() {
  call <1 x i32> @f5(<1 x i32> <i32 0>, <2 x i32> <i32 0, i32 0>,
                     <4 x i32> <i32 0, i32 0, i32 0, i32 0>)
  call <2 x i32> @f5a()
  call <4 x i32> @f5b()
  ret void
}

%AggType = type { i32, float, double }
declare void @f7(%AggType, %AggType* byval)
declare %AggType @f7a()
define void @f8(%AggType* %a) {
  call void @f7(%AggType {i32 0, float 0., double 0.}, %AggType* %a)
  call %AggType @f7a()
  ret void
}
