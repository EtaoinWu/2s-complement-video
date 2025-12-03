#import "@preview/tasteful-pairings:0.1.0": *

#set page(
  paper: "a4",
  margin: (x: 1in, y: 1.25in),
)

#let pairing = font-pairings.at("friendly-weather")

#show heading: set text(font: pairing.heading)
#show math.equation: set text(size: 13pt)
#set text(
  font: pairing.body,
  size: 11pt,
  lang: "en",
)

#set par(
  justify: true,
  leading: 0.8em, // Comfortable line spacing
)

#set heading(numbering: "1.")

// --- Custom Definitions ---
#let ZZ = $bb(Z)$ // Shortcut for Integers
#let NN = $bb(N)$ // Shortcut for Integers

// A function to create nice shaded boxes (replaces tcolorbox)
#let concept_box(title: "", body, color1: luma(100), color2: none) = {
  let color2_ = if color2 == none {
    color1.lighten(92%)
  } else { color2 }
  block(
    fill: color2_, // Light background
    stroke: (left: 4pt + color1), // Dark accent on left
    inset: (x: 1.2em, y: 1em),
    radius: 2pt,
    width: 100%,
    below: 1.5em,
    above: 1.5em,
    [
      #if title != "" [
        #text(weight: "bold", size: 1.05em)[#title] \
        #v(0.3em)
      ]
      #body
    ]
  )
}

#show selector(<nonumber>): set heading(numbering: none)

// --- Title Section ---
#align(center)[
  #text(size: 17pt, weight: "bold")[Lecture Note: Two's Complement] \
  #v(0.5em)
  Etaoin Wu \
  Dec 03, 2025
]

#line(length: 100%, stroke: 1pt + gray)
#v(1em)

// --- Content ---

= Introduction

In standard mathematics, the set of integers $ZZ$ is infinite. You can always add $1$ to a number and get a larger number. However, computers operate with finite resources. A variable must only occupy a finite amount of RAM.

This means computers do not operate in $ZZ$. Intuitively, we can choose to restrict on a subset of $ZZ$, and prohibit all operations whose results are outside this subset. However, early hardware designers found that it's easier to let the result "overflow" and taking a subset of bits. This essentially results in a cyclic #emph[cyclic ring] $ZZ slash n ZZ$, where $n=2^k$ and $k$ is the number of bits in a primitive integer.

= Cyclic rings

== Two examples <nonumber>

In elementary math, you have experienced with some cyclic rings. For example:

- Even and odd numbers form such a ring. A even number plus a even number will always give a even number. The product of two odd numbers must also be odd.

- "The last (decimal) digit of numbers" form such a ring. Without calculating the entire thing, you know that $233+666$ will end in 9, because $3+6=9$; you know that $114514 times 19260817$ will end in 8, because $4 times 7=28$ ends in 8.

In both examples, we classified numbers into different classes: even numbers, or numbers that ends in 7. If you see a formula $a+b=c$, which class $c$ belongs to will be fully determined by the class of $a$ and $b$. 

== Naming them <nonumber>

In both examples, we say that two numbers belong to the same class, if they differ by a multiple of $n$. For even and odd numbers, $n=2$, and we have two classes $"even"={0, 2, 4, 6, ...}$, and $"odd"={1, 3, 5, 7, ...}$.

For the last decimal digit of numbers, we don't have single-word names for them. Since $NN={0, 1, 2, ...}$, we can write $10NN={0, 10, 20, ...}$ to denote the class that ends in 0, and $7+10NN={7, 17, 27, ...}$ to denote the class that ends in 7, etc.. (In this notation, if $a$ is a number, $S$ is a set, then $a+S$ is the set ${a+s | s in S}$, and $a S$ is the set ${a s | s in S}$. Then $10NN$ is all the natural number multiples of 10.)

In this way, we can say that even numbers are $2NN$ and odd numbers are $1+2NN$. In fact, in this way, for every positive integer $n$, we can classify $NN$ into $n NN, 1+n NN, ..., (n-1)+ NN$.

With these names, we can rewrite "A even number plus a odd number will always give a odd number" into mathematical statements like $2NN + (1+2NN) = 1+2NN$. What does "$(2+10NN) dot.c (3+10NN) = 6+10NN$" mean?

== Extending to negatives <nonumber>

The fact "#emph[which class $a+b$ belongs to will be fully determined by the class of $a$ and $b$.]" extends naturally to negative numbers as well. If we simply replace $NN$ with $ZZ$ in the above definitions, let's see what happens:

- In the $ZZ slash 2 ZZ$ example, $2ZZ={..., -4, -2, 0, 2, 4, ...}$ is still all the even numbers in $ZZ$, and $1+2ZZ={..., -3, -1, 1, 3, ...}$ is still all the odd numbers.

- In the $ZZ slash 10 ZZ$ example, $10ZZ={..., -20, -10, 0, 10, 20, ...}$, but $3+10ZZ={..., -27, -17, -7, 3, 13, 23, ...}$ is no more the class of integers that end in $3$. However, they can still calculate fine: $-7 in 3+10ZZ, -18 in 2+10 ZZ$; please verify that $(-7)+(-18)in 5+10ZZ$ and  $(-7)times(-18)in 6+10ZZ$.

The collection ${n ZZ, 1+n ZZ,..., (n-1)+n ZZ}$ is called the quotient ring $ZZ slash n ZZ$. (If you want to know what's a ring and what's a quotient precisely, feel free to read some basic abstract algebra!)

#concept_box(title: "Quotient Ring", color1: green)[
  For a natural number $n$, we define:
  - $a + n ZZ = {..., a-2n, a-n, a, a+n, a+2n, ...}$
  - and the quotient ring $ZZ slash n ZZ = {n ZZ, 1+n ZZ,..., (n-1)+n ZZ}$.
  - For every integer $x$, there exists a number $a in {0, 1, ..., n-1}$ such that $x in a + n ZZ$; in fact, this set is just $x + n ZZ$.
]

Just as the $n=2$ and $n=10$ examples above, the basic operations (except division) are preserved in them:

#concept_box(title: "Laws of a Quotient Ring")[
  For a quotient ring $ZZ slash n ZZ$, we have:
  - $(a+n ZZ)+(b+n ZZ)=(a+b)+n ZZ$, and the latter is equal to some $p+n ZZ$;
  - $(-a ZZ)=q+n ZZ$ for some $q$;
  - $(a+n ZZ)(b+n ZZ)=(a b)+n ZZ$, and the latter is equal to some $q+n ZZ$.
  In the above, $p, q, r$ are numbers in ${0, 1, ..., n-1}$.
]

In the video, the "2-digit calculator" does calculations on the $ZZ slash 100 ZZ$ ring. We have shown that addition and multiplication works fine. In fact, when you see a $k$-bit computer, it does compute in $ZZ slash 2^k ZZ$. The "overflow" and "underflow" corresponds to the behavior of finding a representative element in ${0, 1, ..., n-1}$.

= Naming the classes in a quotient ring

In a quotient ring, you don't have to choose ${0, 1, ..., n-1}$ as your representative. In fact, you can say that the two elements of $ZZ slash 2 ZZ$ are $42 + 2 ZZ$ and $73 + 2 ZZ$, and it's just as valid.

In the video, this is called "naming the elements". Here, we say we are picking representative elements in the ring. To be exact, we consider the following representatives:

#concept_box(title: [The "signed" representatives], color1: green)[
  For a quotient ring $ZZ slash n ZZ$ where $n$ is even:
  - ${-n/2, -n/2+1,..., -1}$ are the negative representatives;
  - ${0, 1, ..., n/2-1}$ are the positive representatives.
]

This gives the ${-50, -49, ..., 48, 49}$ representative shown in the 2-digit example.

= Two's Complement (Binary)

Modern computers use binary ($n = 2^k$). In CS terms, a $k$-bit integer has $2^k$ unique states; in math terms, the ring $ZZ slash 2^k ZZ$ has $2^k$ elements. Two of the integer types represents two ways of picking representatives in the elements of the ring.

- *Unsigned* Integers: Range ${0, 1, ..., 2^k - 1}$.
- *Signed* Integers: Range ${0, 1, ..., 2^(k-1) - 1, -2^(k-1), ..., -1}$.

== Finding negative <nonumber>
To find the negation of an element $-x+2^k ZZ$, we just want to find another number $y$ that is a representative and that $-x+ZZ = y+2^k ZZ$; this is  equivalently $y in -x+ZZ$, and if $x$ is in the range of $[1, 2^k-1]$, we can just pick $y=-x+2^k$.

This is then equal to $(2^k-1)-x+1$. However, when calculating $(2^k-1)-x$, we can realize that $2^k-1$ is the all-1 string, and subtracting from it is just flipping every bit. Therefore, $-x equiv 2^k-x = (2^k-1)-x+1="bitwise_negate"(x)+1$.

== The sign bit <nonumber>
The reason we set $2^(k-1)$ to be negative is that testing negativity is easy; we can look at the highest bit in the binary representation. For example, if we are dealing with $n=2^4$, then the negative representatives are ${1000=-8, 1001=-7, ..., 1111=-1}$, and they all have 1 as their highest bit; the nonnegative representatives are ${0000=0, ..., 0111=7}$.

= Extra notes

== The Asymmetry
Because $0$ is technically "positive" (it has a 0 MSB), there is one more negative number than positive number.
- Max Positive: $011...1 = 2^(k-1) - 1$
- Max Negative: $100...0 = -2^(k-1)$

*Note:* You cannot take the negative of the most negative number (e.g., -128 in 8-bit). Mathematically, it is because $-128+256ZZ = 128+256ZZ$. So, negation maps it to itself.

== Overflow & underflow

Since we have a very simple way of detecting negative-ness (the sign bit), it's easy to detect overflow and underflow. If two numbers has 0 at their highest bit and the addition result has 1 as their highest bit, there is an overflow. Underflow can be defined analogously.

== Historical note

You might have heard of "sign-and-magnitude" and "one's complement" as alternative ways to encode negative integers. In the very early days of computing, they used to exist in some very old architectures. However, people quickly realized that two's complement makes signed addition and multiplication smooth, because they don't even need to exist separately. It is also mathematically the cleanest (for the same reason). Sign-magnitude exists in floating point numbers (IEEE754) and that's it.

All modern CPUs that you can buy (x86, ARM, RISC-V, or even MIPS, POWER) use two's complement. Modern programming languages like C20 and C++23 enforces two's complement. Therefore, I believe _only_ two's complement should be taught in a computer architecture class; sign-magnitude and one's complement only belongs to computer history, along with segmented memory and branch delay slots.
