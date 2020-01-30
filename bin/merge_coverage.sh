#! /usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

main() {
    find . -iname '*.dart' | grep -v '_test.dart' | grep 'lib/src' | sed "s/\(^\.\/\)\(.*\)/SF:\2/g" | sort > all
    grep SF: $1 | sort > covered
    comm -23 all covered > not_covered
    cat not_covered | awk '{print $0; print "end_of_record"}' > not_covered_report
    cat cov not_covered_report
}

display_usage() { 
    echo -e "\nUsage:\n merge_coverage.sh path/to/lcov.info \n" 
}

if [  $# -lt 1 ] 
then 
    display_usage
exit 1
fi 

main "${@}"

