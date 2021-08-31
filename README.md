# Shodan Explorer
This script automates searching with Shodan.io for IoT devices and creates a text file containing Shodan's output. This project is in the making and is my first attempt at creating an "advanced" script.

Use: `./Shodan-Explorer.sh -q "search query" -l "limit results" -f "filename"`

Feel free to contact me if you encounter any bugs/problems!

# Instructions
Please make sure you have executed the following commands before running the script:
```
pip install shodan
shodan init <Your API Key>
```
(Which can be found here: [https://account.shodan.io/](https://account.shodan.io/))

And that the script has executable priviledges:
```
chmod +x Shodan-Explorer.sh
```
