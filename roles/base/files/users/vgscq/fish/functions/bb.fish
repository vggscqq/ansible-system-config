function bb --wraps bc --description "BC quiet"
    rlwrap bc | awk '{
        if (match($0, /^[0-9]+(\.[0-9]+)?$/)) {
            split($0, parts, ".")
            len = length(parts[1])
            res = ""
            for (i = 0; i < len; i++) {
                res = substr(parts[1], len - i, 1) res
                if (i % 3 == 2 && i != len - 1) {
                    res = "," res
                }
            }
            if (length(parts) > 1) {
                res = res "." parts[2]
            }
            print "> " res
        } else {
            print "> " $0
        }
    }'
end


#function bb --wraps bc --description "BC quiet"
#    bc -q $argv
#end
