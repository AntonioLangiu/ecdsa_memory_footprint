#!/bin/bash -e

# This script will build each configuration 6 times:
# 3 times for posix:
#  - a:without verification
#  - b:with sha256
#  - c:with ecdsa validation
#  - d:with both
# 3 times for Contiki:
#  - e:without verification
#  - f:with sha256
#  - g:with ecdsa validation
#  - h:with both

libs="tinydtls polarssl matrixssl micro-ecc tinycrypt wolfssl libtomcrypt"
tests="a b c d"

store_size() {
    size $2 > $1.size
}

get_data_size() {
    (cat $1/$2.size | tail -1 | cut -f 1 | xargs) || echo *
}

evaluate() {
    (echo "Evaluating $1"
    cd $1
    source autogen.sh
    # Posix part
    download
    build_posix
    make posix
    store_size a verify.exec
    make posix VERIFY_CONF="-DWITH_HASH"
    ./verify.exec && store_size b verify.exec
    make posix VERIFY_CONF="-DWITH_VERIFICATION"
    ./verify.exec && store_size c verify.exec
    make posix VERIFY_CONF="-DWITH_VERIFICATION -DWITH_HASH"
    ./verify.exec && store_size d verify.exec
    # Contiki part
    #download
    #build_contiki
    echo "$1 evaluated")
}

result="Library\t\t| main\t| SHA2\t| ECC\t| ECDSA\n"
result="$result-----------------------------------------------\n"
for lib in $libs; do
    result="$result$lib "
    evaluate $lib
    for value in $tests; do
        r=$(get_data_size $lib $value)
        result="$result\t $(printf "%5d" $r)"
    done
    result="$result\n"
done
echo -e $result
