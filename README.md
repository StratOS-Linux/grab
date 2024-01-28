# grab
<!-- <img title="" src="https://i.imgur.com/Kq4ER0L.png" alt="Linux Club Logo" data-align="center"> -->

# Grab

## About

- A fetch tool written in POSIX `sh` and `C++`

- Meant for use in [StratOS](https://github.com/StratOS-Linux/StratOS-iso) (A Arch-based distro made by Linux hobbyists)

- For further info on how to contribute to this project, refer to [CONTRIBUTING.md](CONTRIBUTING.md)

## C++

The shell is too slow for operations to display such a fetch program. Since this program will possibly be run on a user's terminal on startup, speed is crucial.  Additionally, optimizing shell scripts almost always leads to unreadable code, which makes it harder for people to contribute. Hence the rewrite in C++ is to be preferred. The shell version is still here to stay consistent to other fetch scripts using shell.

## Todo
`C++`:
- [x] Fetch the info dynamically
- [x] Cache the info for faster execution
- [ ] Configuration file
- [ ] Code cleanup
- [ ] Testing on multiple systems

`sh`:
- [x] Colored output
- [ ] Fetch the info dynamically (most likely borrow the scraping script from an existing fetch program)
- [ ] Document the code
- [ ] Configuration file
- [ ] Optimize the script cause its relatively slow as of now

## Contributing

`sh`:
- Functionalize everything in a format like:
```shell
# Description of function
# (paramters, asd=default_value)
function_name() {
    ...
}
```

- For further info on how to contribute to this project, refer to [CONTRIBUTING.md](CONTRIBUTING.md)
