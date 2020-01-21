#ifndef PB_STACK_H
#define PB_STACK_H

// you need to define STACK before including this.

#define stack_init() \
  STACK = 0x3F

// push3/push2/push1
// can be nested, but
// pop1/pop2/pop3
// have to recurse.
void push3() {
  store( STACK, sC );
  STACK -= 1;
 push2:
  store( STACK, sB );
  STACK -= 1;
 push1:
  store( STACK, sA );
  STACK -= 1;
}

void pop1() {
  STACK += 1;
  fetch( STACK, sA);
}
void pop2() {
  pop1();
  STACK += 1;
  fetch( STACK, sB );
}
void pop3() {
  pop2();
  STACK += 1;
  fetch( STACK, sC );
}


#endif
