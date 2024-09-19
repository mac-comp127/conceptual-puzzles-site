module DatabaseEnum
  def self.define(enum_name)
    Object.const_set(
      enum_name.to_s.camelize,
      Class.new do
        @all = Attempt.connection.query("SELECT unnest(enum_range(NULL::#{enum_name}))").flatten

        def self.all
          @all
        end

        @all.each do |value|
          define_singleton_method value do  # for fail-fast checking of mistyped names
            value
          end
        end
      end
    )
  end
end
