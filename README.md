

# coinmarketcap-icons

coinmarketcap-icons is a simple Ruby script that can be used to download cryptocurrency icons from [CoinMarketCap.com](https://coinmarketcap.com/). The script can download icons of multiple sizes including 16x16, 32x32, 64x64, or 128x128 pixels, and allows you to customize the naming of the icons based on slug, rank, id, or symbol.

## Requirements

- Ruby 2.0 or higher

## Installation

1. Clone or download this repository.
```
git clone https://github.com/acidtib/coinmarketcap-icons.git
```

2. Install the required gems by running the following command in your terminal: 
```sh
bundle install
```

## Usage

To download icons, simply run the `./bin/cli` script with the desired options. Here is the basic syntax:

```
./bin/cli fetch [options]
```

### Options

- `--size SIZE`: The size of the icons to download. Available options are 16, 32, 64, or 128. If not specified, the default is `128`.
- `--name NAME`: The name to use for the downloaded icons. Available options are `slug`, `rank`, `id`, or `symbol`. If not specified, the default is `slug`.
- `--json`: Save a json file with the icons details `icons.json`

### Examples

To download only the 128x128 icons and save them with their respective `slug` names, run the following command:

```
./bin/cli fetch --name slug --size 128
```

## Contributing

Contributions are welcome! If you would like to contribute to this project, please fork this repository and submit a pull request.

## License

This project is licensed under the MIT License.