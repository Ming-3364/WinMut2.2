ALGOS=(WinMut WinMutNo AccMut AccMutNo validate timing)

for ALGO in ${ALGOS[@]}; do
    rm -rf ${ALGO}
    mkdir ${ALGO}
    cp -r origin/* ${ALGO}/
done