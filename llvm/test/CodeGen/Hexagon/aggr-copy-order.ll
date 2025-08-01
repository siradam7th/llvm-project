; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc -mtriple=hexagon -mattr=-packets -hexagon-check-bank-conflict=0 < %s | FileCheck %s

target triple = "hexagon"

%s.0 = type { i32, i32, i32 }

; Function Attrs: nounwind
define void @f0(ptr %a0, ptr %a1) #0 {
; CHECK-LABEL: f0:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r2 = memw(r1+#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r29 = add(r29,#-8)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     memw(r0+#0) = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     memw(r29+#0) = r0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r2 = memw(r1+#4)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     memw(r29+#4) = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r29 = add(r29,#8)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     memw(r0+#4) = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r2 = memw(r1+#8)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     memw(r0+#8) = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = alloca ptr, align 4
  %v1 = alloca ptr, align 4
  store ptr %a0, ptr %v0, align 4
  store ptr %a1, ptr %v1, align 4
  %v2 = load ptr, ptr %v0, align 4
  %v3 = load ptr, ptr %v1, align 4
  call void @llvm.memcpy.p0.p0.i32(ptr align 4 %v2, ptr align 4 %v3, i32 12, i1 false)
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0.p0.i32(ptr nocapture writeonly, ptr nocapture readonly, i32, i1) #1

attributes #0 = { nounwind }
attributes #1 = { argmemonly nounwind }
