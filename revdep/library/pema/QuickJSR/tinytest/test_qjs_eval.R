expect_equal(1, qjs_eval("1"))
expect_equal(2.5, qjs_eval("1 + 1.5"))
expect_equal("Hello World!", qjs_eval("'Hello World!'"))
expect_equal("Hello World!", qjs_eval("'Hello' + ' ' + 'World!'"))
expect_equal(list(a = 1, b = "2"), qjs_eval("var t = {'a' : 1, 'b' : '2'}; t"))

expect_equal(
  tryCatch(
    {
      qjs_eval("non_exist_fun(1)")
    },
    error = function(e) {
      as.character(e)
    }
  ),
  "Error: JavaScript Exception: \nReferenceError: non_exist_fun is not defined\n    at <eval> (<input>:1:1)\n\n"
)

expect_equal(
  capture.output(qjs_eval("console.log('Testing value')")),
  "Testing value"
)
