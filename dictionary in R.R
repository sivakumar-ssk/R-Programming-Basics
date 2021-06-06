#Is there a way to create a "dictionary" in R, 
#such that it has pairs? Something to the effect of:
  
x=dictionary(c("Hi","Why","water") , c(1,5,4))
x["Why"]=5
  I'm asking this because I am actually looking for a two categorial variables function.

So that if x=dictionary(c("a","b"),c(5,2))

     x  val
1    a  5 
2    b  2 
I want to compute x1^2+x2 on all combinations of x keys

     x1 x2 val1  val2  x1^2+x2
1    a  a   5     5      30
2    b  a   2     5      9
3    a  b   5     2      27
4    b  b   2     2      6
And then I want to be able to retrieve the result using x1 and x2. Something to the effect of: get_result["b","a"] = 9

what is the best, efficient way to do this?

r
dictionary
Share
Improve this question
Follow
edited Sep 7 '18 at 14:37
  
  acylam
  16.6k55 gold badges2727 silver badges4040 bronze badges
  asked Oct 19 '11 at 9:10

eran
12.5k2828 gold badges8787 silver badges133133 bronze badges
would a data.frame not be enough for your task? what's the reason for needing a dictionary? - acylam Sep 7 '18 at 14:01
Add a comment
4 Answers

36

I know three R packages for dictionaries: hash, hashmap, and dict.

Update July 2018: a new one, container.

Update September 2018: a new one, collections

hash
Keys must be character strings. A value can be any R object.

library(hash)
## hash-2.2.6 provided by Decision Patterns
h <- hash() 
# set values
h[["1"]] <- 42
h[["foo"]] <- "bar"
h[["4"]] <- list(a=1, b=2)
# get values
h[["1"]]
## [1] 42
h[["4"]]
## $a
## [1] 1
## 
## $b
## [1] 2
h[c("1", "foo")]
## <hash> containing 2 key-value pair(s).
##   1 : 42
##   foo : bar
h[["key not here"]]
## NULL
To get keys:

keys(h)
## [1] "1"   "4"   "foo"
To get values:

values(h)
## $`1`
## [1] 42
## 
## $`4`
## $`4`$a
## [1] 1
## 
## $`4`$b
## [1] 2
## 
## 
## $foo
## [1] "bar"
The print instance:

h
## <hash> containing 3 key-value pair(s).
##   1 : 42
##   4 : 1 2
##   foo : bar
The values function accepts the arguments of sapply:

values(h, USE.NAMES=FALSE)
## [[1]]
## [1] 42
## 
## [[2]]
## [[2]]$a
## [1] 1
## 
## [[2]]$b
## [1] 2
## 
## 
## [[3]]
## [1] "bar"
values(h, keys="4")
##   4
## a 1
## b 2
values(h, keys="4", simplify=FALSE)
## $`4`
## $`4`$a
## [1] 1
## 
## $`4`$b
## [1] 2
hashmap
See https://cran.r-project.org/web/packages/hashmap/README.html.

hashmap does not offer the flexibility to store arbitrary types of objects.

Keys and values are restricted to "scalar" objects (length-one character, numeric, etc.). The values must be of the same type.

library(hashmap)
H <- hashmap(c("a", "b"), rnorm(2))
H[["a"]]
## [1] 0.1549271
H[[c("a","b")]]
## [1]  0.1549271 -0.1222048
H[[1]] <- 9
Beautiful print instance:

H
## ## (character) => (numeric)  
## ##         [1] => [+9.000000]
## ##         [b] => [-0.122205]
## ##         [a] => [+0.154927]
Errors:

H[[2]] <- "Z"
## Error in x$`[[<-`(i, value): Not compatible with requested type: [type=character; target=double].
H[[2]] <- c(1,3)
## Warning in x$`[[<-`(i, value): length(keys) != length(values)!
dict
Currently available only on Github: https://github.com/mkuhn/dict

Strengths: arbitrary keys and values, and fast.

library(dict)
d <- dict()
d[[1]] <- 42
d[[c(2, 3)]] <- "Hello!" # c(2,3) is the key
d[["foo"]] <- "bar"
d[[4]] <- list(a=1, b=2)
d[[1]]
## [1] 42
d[[c(2, 3)]]
## [1] "Hello!"
d[[4]]
## $a
## [1] 1
## 
## $b
## [1] 2
Accessing to a non-existing key throws an error:

d[["not here"]]
## Error in d$get_or_stop(key): Key error: [1] "not here"
But there is a nice feature to deal with that:

d$get("not here", "default value for missing key")
## [1] "default value for missing key"
Get keys:

d$keys()
## [[1]]
## [1] 4
## 
## [[2]]
## [1] 1
## 
## [[3]]
## [1] 2 3
## 
## [[4]]
## [1] "foo"
Get values:

d$values()
## [[1]]
## [1] 42
## 
## [[2]]
## [1] "Hello!"
## 
## [[3]]
## [1] "bar"
## 
## [[4]]
## [[4]]$a
## [1] 1
## 
## [[4]]$b
## [1] 2
Get items:

d$items()
## [[1]]
## [[1]]$key
## [1] 4
## 
## [[1]]$value
## [[1]]$value$a
## [1] 1
## 
## [[1]]$value$b
## [1] 2
## 
## 
## 
## [[2]]
## [[2]]$key
## [1] 1
## 
## [[2]]$value
## [1] 42
## 
## 
## [[3]]
## [[3]]$key
## [1] 2 3
## 
## [[3]]$value
## [1] "Hello!"
## 
## 
## [[4]]
## [[4]]$key
## [1] "foo"
## 
## [[4]]$value
## [1] "bar"
No print instance.

The package also provides the function numvecdict to deal with a dictionary in which numbers and strings (including vectors of each) can be used as keys, and that can only store vectors of numbers.

Share
Improve this answer
Follow
edited Sep 7 '18 at 11:27
  answered Jun 15 '17 at 14:41

Stéphane Laurent
48.1k1414 gold badges8585 silver badges169169 bronze badges
Add a comment

6

In that vectors, matrices, lists, etc. behave as "dictionaries" in R, you can do something like the following:

> (x <- structure(c(5,2),names=c("a","b"))) ## "dictionary"
a b 
5 2 
> (result <- outer(x,x,function(x1,x2) x1^2+x2))
   a  b
a 30 27
b  9  6
> result["b","a"]
[1] 9
If you wanted a table as you've shown in your example, just reshape your array...
  
  > library(reshape)
  > (dfr <- melt(result,varnames=c("x1","x2")))
  x1 x2 value
  1  a  a    30
  2  b  a     9
  3  a  b    27
  4  b  b     6
  > transform(dfr,val1=x[x1],val2=x[x2])
  x1 x2 value val1 val2
  1  a  a    30    5    5
  2  b  a     9    2    5
  3  a  b    27    5    2
  4  b  b     6    2    2
  Share
  Improve this answer
  Follow
  edited Oct 19 '11 at 10:48
answered Oct 19 '11 at 10:42
  
  hatmatrix
  36.8k3737 gold badges126126 silver badges217217 bronze badges
  1
  Parentheses around the assignment expressions are there just to print the results. - hatmatrix Oct 19 '11 at 10:50
Add a comment

4

You can use just data.frame and row.names to do this:

x=data.frame(row.names=c("Hi","Why","water") , val=c(1,5,4))
x["Why",]
[1] 5
Share
Improve this answer
Follow
answered Jul 2 '20 at 16:11
  
  xm1
  1,08711 gold badge1111 silver badges2222 bronze badges
  Add a comment
  
  1
  
  See my answer to a very recent question. In essence, you use environments for this type of functionality.
  
  For the higher dimensional case, you may be better off using an array (twodimensional) if you want the easy syntax for retrieving the result (you can name the rows and columns). As an alternative,you can paste together the two keys with a separator that doesn't occur in them, and then use that as a unique identifier.

To be specific, something like this:

tmp<-data.frame(x=c("a", "b"), val=c(5,2))
tmp2<-outer(seq(nrow(tmp)), seq(nrow(tmp)), function(lhs, rhs){tmp$val[lhs] + tmp$val[rhs]})
dimnames(tmp2)<-list(tmp$x, tmp$x)
tmp2
tmp2["a", "b"]

Also refer : http://optimumsportsperformance.com/blog/creating-a-data-dictionary-function-in-r/