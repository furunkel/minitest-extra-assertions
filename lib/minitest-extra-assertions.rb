module MiniTest
  module Assertions
    def assert_false obj, msg = nil
      msg = message(msg) { "<false> expected but was #{mu_pp(obj)}" }
      assert obj == false, msg
    end

    def assert_true obj, msg = nil
      msg = message(msg) { "<true> expected but was #{mu_pp(obj)}" }
      assert obj == true, msg
    end

    # This actually conflicts with behavior in minitest proper; this mimics the
    # old Test::Unit implementation, relying on the #=~ method of the actual object.
    # Minitest calls #=~ on the matcher instead, which is honestly better by the POLS
    # but makes it much more difficult to test objects that have custom #=~ implementations.
    def assert_match exp, act, msg = nil
      msg = message(msg) { "Expected #{mu_pp(exp)} to match #{mu_pp(act)}" }
      assert_respond_to act, "=~"
      exp = Regexp.new(Regexp.escape(exp)) if String === exp
      assert act =~ exp, msg
    end

    def assert_between(*args)
      hi, lo, exp, msg = if args.first.is_a?(Range)
                           [args.first.begin, args.first.end, args[1], args[2]]
                         else
                           args[0..3]
                         end
      msg = message(msg) { "Expected #{mu_pp(exp)} to be between #{mu_pp(lo)} and #{mu_pp(hi)}" }
      assert (lo < exp && exp < hi) || (hi < exp && exp < lo), msg
    end
  end
end

