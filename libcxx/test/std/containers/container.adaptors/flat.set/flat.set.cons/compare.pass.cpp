//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// UNSUPPORTED: c++03, c++11, c++14, c++17, c++20

// <flat_set>

// explicit flat_set(const key_compare& comp);
// template <class Alloc>
//   flat_set(const key_compare& comp, const Alloc& a);

#include <deque>
#include <flat_set>
#include <functional>
#include <type_traits>
#include <vector>

#include "test_macros.h"
#include "../../../test_compare.h"
#include "test_allocator.h"
#include "MinSequenceContainer.h"
#include "min_allocator.h"

template <class KeyContainer>
constexpr void test_compare() {
  {
    using C = test_less<int>;
    auto m  = std::flat_set<int, C, KeyContainer>(C(3));
    assert(m.empty());
    assert(m.begin() == m.end());
    assert(m.key_comp() == C(3));
  }
  {
    // The one-argument ctor is explicit.
    using C = test_less<int>;
    static_assert(std::is_constructible_v<std::flat_set<int, C, KeyContainer>, C>);
    static_assert(!std::is_convertible_v<C, std::flat_set<int, C, KeyContainer>>);

    static_assert(std::is_constructible_v<std::flat_set<int, std::less<int>, KeyContainer>, std::less<int>>);
    static_assert(!std::is_convertible_v<std::less<int>, std::flat_set<int, std::less<int>, KeyContainer>>);
  }
}

template <template <class...> class KeyContainer>
constexpr void test_compare_alloc() {
  {
    using C  = test_less<int>;
    using A1 = test_allocator<int>;
    auto m   = std::flat_set<int, C, KeyContainer<int, A1>>(C(4), A1(5));
    assert(m.empty());
    assert(m.begin() == m.end());
    assert(m.key_comp() == C(4));
    auto keys = std::move(m).extract();
    assert(keys.get_allocator() == A1(5));
  }
  {
    // explicit(false)
    using C                                        = test_less<int>;
    using A1                                       = test_allocator<int>;
    std::flat_set<int, C, KeyContainer<int, A1>> m = {C(4), A1(5)};
    assert(m.empty());
    assert(m.begin() == m.end());
    assert(m.key_comp() == C(4));
    auto keys = std::move(m).extract();
    assert(keys.get_allocator() == A1(5));
  }
}

constexpr bool test() {
  {
    // The constructors in this subclause shall not participate in overload
    // resolution unless uses_allocator_v<container_type, Alloc> is true.

    using C  = test_less<int>;
    using A1 = test_allocator<int>;
    using A2 = other_allocator<int>;
    using V1 = std::vector<int, A1>;
    using V2 = std::vector<int, A2>;
    using M1 = std::flat_set<int, C, V1>;
    using M2 = std::flat_set<int, C, V2>;
    static_assert(std::is_constructible_v<M1, const C&, const A1&>);
    static_assert(std::is_constructible_v<M2, const C&, const A2&>);
    static_assert(!std::is_constructible_v<M1, const C&, const A2&>);
    static_assert(!std::is_constructible_v<M2, const C&, const A1&>);
  }
  test_compare<std::vector<int>>();
  test_compare<MinSequenceContainer<int>>();
  test_compare<std::vector<int, min_allocator<int>>>();

  test_compare_alloc<std::vector>();

#ifndef __cpp_lib_constexpr_deque
  if (!TEST_IS_CONSTANT_EVALUATED)
#endif
  {
    test_compare<std::deque<int>>();
    test_compare_alloc<std::deque>();
  }

  return true;
}

int main(int, char**) {
  test();
#if TEST_STD_VER >= 26
  static_assert(test());
#endif

  return 0;
}
