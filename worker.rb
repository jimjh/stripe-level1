#!/usr/bin/env ruby
require 'openssl'

tree, parent, timestamp, difficulty, start = ARGV
body = <<-EOS
tree #{tree}
parent #{parent}
author Jim Lim <jim@quixey.com> #{timestamp} -0800
committer Jim Lim <jim@quixey.com> #{timestamp} -0800

Give me a Gitcoin
EOS

STDERR.puts "launched with #{tree} #{parent} #{timestamp} #{difficulty} #{start}"

counter = start.to_i
while true
  temp   = "#{body}\nnonce #{counter}"
  commit = "commit #{temp.size}\0#{temp}"
  hash   = OpenSSL::Digest::SHA1::digest(commit).unpack('H*')[0]
  if hash < difficulty
    STDERR.puts temp
    STDERR.puts hash
    IO.write 'body', temp
    exit 1
  end
  counter += 1
end
