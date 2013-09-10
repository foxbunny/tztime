// Generated by CoffeeScript 1.6.3
var commentRe, compile, dahelpers, existsSync, mkdirSync, processDir, readFileSync, readdirSync, skip, sourceDir, statSync, targetDir, writeFileSync, _ref;

_ref = require('fs'), readFileSync = _ref.readFileSync, writeFileSync = _ref.writeFileSync, readdirSync = _ref.readdirSync, statSync = _ref.statSync, existsSync = _ref.existsSync, mkdirSync = _ref.mkdirSync;

dahelpers = require('dahelpers');

commentRe = /^ *(?:#|# (.*))$/;

compile = function(filename) {
  var contents, lines, mkd, paragraphs, toc;
  contents = readFileSync(filename, {
    encoding: 'utf-8'
  });
  lines = contents.split('\n');
  paragraphs = [];
  (function(block) {
    return lines.forEach(function(line, idx) {
      var match;
      match = line.match(commentRe);
      if (match) {
        if (match[1] != null) {
          block.push(match[1]);
        } else {
          paragraphs.push(block);
          block = [];
        }
      }
    });
  })([]);
  paragraphs = paragraphs.map(function(paragraph) {
    if (!paragraph[0]) {
      return '';
    }
    if (paragraph[0][0] === ' ') {
      return paragraph.join('\n') + '\n';
    } else {
      return dahelpers.wrap(paragraph.join(' '));
    }
  });
  toc = '';
  paragraphs = paragraphs.map(function(paragraph) {
    var hash, m, title, tocIndent, tocLevel, tocSymbol;
    if (paragraph[0] === '#') {
      m = paragraph.match(/^(#+) (.*)$/);
      tocLevel = m[1].length;
      title = m[2];
      tocSymbol = tocLevel % 2 ? '-' : '+';
      tocIndent = new Array(2 + ((tocLevel - 2) * 2)).join(' ');
      hash = dahelpers.slug(paragraph);
      if (tocLevel > 1) {
        toc += tocIndent + tocSymbol + ' [' + title + '](#' + hash + ')\n';
      }
      return paragraph + ' ' + dahelpers.a('', {
        name: hash
      });
    } else {
      return paragraph;
    }
  });
  mkd = paragraphs.join('\n\n');
  mkd = mkd.replace('::TOC::', toc);
  return mkd;
};

processDir = function(dir, target, skip) {
  var ext, f, fstat, index, mkd, name, path, _i, _len, _results;
  index = readdirSync(dir);
  if (!existsSync(target)) {
    mkdirSync(target);
  }
  _results = [];
  for (_i = 0, _len = index.length; _i < _len; _i++) {
    f = index[_i];
    if (f === skip) {
      continue;
    }
    path = "" + dir + "/" + f;
    fstat = statSync(path);
    if (fstat.isDirectory()) {
      console.log("Entering directory " + path);
      _results.push(processDir(path, "" + target + "/" + f));
    } else {
      name = f.split('.').slice(0, -1).join('.');
      ext = f.split('.').slice(-1)[0];
      if (ext === 'coffee') {
        console.log("Processing " + path);
        mkd = compile(path);
        console.log("Writing to " + target + "/" + name + ".mkd");
        _results.push(writeFileSync("" + target + "/" + name + ".mkd", mkd, {
          encoding: 'utf-8'
        }));
      } else {
        _results.push(console.log("Skipping " + path));
      }
    }
  }
  return _results;
};

sourceDir = process.argv[2];

targetDir = process.argv[3];

skip = process.argv[4];

processDir(sourceDir, targetDir, skip);
