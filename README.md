# pegboard_pen_cup

It's a cup to hold pens with hooks to fit standard 3/16" hole pegboard. `scad`
makes it easy to adjust the variables at the top of the file to get a cup the
size you want.

## Usage

It requires [BOSL](https://github.com/revarbat/BOSL).

## Known Issues

The join of the hook to the box is a weak point and is prone to failure when
excessive downward force is applied to the far edge of the box. The issue is
aggravated the greater the depth of the box.

This issue can be mitigated by adding infill to make sure the inside of the
hook tube has extra contact area with the box.

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
