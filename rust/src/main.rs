fn main() {
    println!("hello?");

    let mut x = 27u;
    loop {
        if x == 1 { break; }
        if x % 2 == 0 {
            x = x / 2;
        } else {
            x = x * 3 + 1;
        }
        println!("{}", x);
    }
}
