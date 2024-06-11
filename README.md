# Nerd
tool designed to extract domain names from input text, optionally adding prefixes or suffixes to each domain, and then outputting the modified domains. 

# Installation

```
git clone https://github.com/XJOKZVO/Nerd.git
```

# Options:
```
   _   _                     _ 
  | \ | |   ___   _ __    __| |
  |  \| |  / _ \ | '__|  / _` |
  | |\  | |  __/ | |    | (_| |
  |_| \_|  \___| |_|     \__,_|
                               

Usage: Nerd.pl [-i input_file] [-o output_file] [-p prefix] [-s suffix] [-h]
Options:
  -i, --input FILE   Read domains from FILE instead of stdin
  -o, --output FILE  Write output to FILE instead of stdout
  -p, --prefix STR   Add STR as prefix to each domain
  -s, --suffix STR   Add STR as suffix to each domain
  -h, --help         Display this help message
```

# Usage:
```
Examples:
  cat logs.txt | Nerd.pl
  Nerd.pl -i logs.txt
  cat logs.txt | Nerd.pl -p "https://" -s "/api"
  Nerd.pl -i logs.txt -o output.txt
  Nerd.pl -h
```
