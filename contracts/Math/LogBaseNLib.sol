// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

/**
 * @dev Computes logarithms
 *
 * Note: Only logbases with a magic constant are computable
 *
 * Inspired from
 * https://medium.com/coinmonks/math-in-solidity-part-5-exponent-and-logarithm-9aef8515136e
 *
 * Log2(x) is computed using bit shifting.
 * LogN(x) is computed using Log2(x) and a precomputed stored LogN(2).
 *
 * From Wolfrom Alpha we get the LogN(2) magic constants.
 * The constants hold in 212 bits so overflow by multiplication is impossible when multiplying
 * with a number [1..256]. To compute logbaseN(x) we compute Log2(x) and multiply with the magic
 * constant, we then check for rounding errors.
 */
library LogBaseNLib {
    uint256 constant DIVISOR = 10000000000000000000000000000000000000000000000000000000000000000;
    uint256 constant logE = 6931471805599453094172321214581765680755001343602552541206800094;
    uint256 constant logb3 = 6309297535714574370995271143427608542995856401318804278706549438;
    uint256 constant log5 = 4306765580733930506701065687639656320697919320797604493219760379;
    uint256 constant log6 = 3868528072345415868702461384678208764651418594571034283894949288;
    uint256 constant log7 = 3562071871080221765141770780012905292977571627728137000395764577;
    uint256 constant log9 = 3154648767857287185497635571713804271497928200659402139353274719;
    uint256 constant log10 = 3010299956639811952137388947244930267681898814621085413104274611;
    uint256 constant log11 = 2890648263178878592662110077002635661912946159856960036263415677;
    uint256 constant log12 = 2789429456511298431910440810378856031047943375964730679726960034;
    uint256 constant log13 = 2702381544273197412941080034506422943986442023136811494027824806;
    uint256 constant log14 = 2626495350371935479789068685650807206006615947069198098920425661;
    uint256 constant log15 = 2559580248098154893876776788648022704049418797589011422685154309;
    uint256 constant log17 = 2446505421182260303897614912319778073942609656083636977863503925;
    uint256 constant log18 = 2398124665681314447356841649105230617681779300190705659786449007;
    uint256 constant log19 = 2354089133666382364469654600368418538354067766278160472881323685;
    uint256 constant log20 = 2313782131597591742636977010976404958909655073735658618396177941;
    uint256 constant log21 = 2276702486969529979820759721008909956410655912413232961670749567;
    uint256 constant log22 = 2242438242175754394775623384034804708979128824422220097257617110;
    uint256 constant log23 = 2210647294575037461497960540954335148467391036765566540280592346;
    uint256 constant log24 = 2181042919855315592293378064433883886276604254994997676147381564;
    uint256 constant log25 = 2153382790366965253350532843819828160348959660398802246609880189;
    uint256 constant log26 = 2127460535533631536061877841532067960056641697399960354179442261;
    uint256 constant log27 = 2103099178571524790331757047809202847665285467106268092902183146;
    uint256 constant log28 = 2080145976765094575985509746618704601447499042921092856074209067;
    uint256 constant log29 = 2058468324604344573068002505012136877694593312455723670755355357;
    uint256 constant log30 = 2037950470905061900327447492032724497319971054202895772592430526;
    uint256 constant log31 = 2018490865820998507185164002939246825097018037267831515006348329;
    uint256 constant log48 = 1790522317510413680073320266212350834996642687339104291537228584;
    uint256 constant log56 = 1721954337940981172444876200699574737999808059006431467544710184;
    uint256 constant log60 = 1692938075987814331909628714155439618434950064179520296886160190;
    uint256 constant log112 = 1468999356504446941665683000183106657656225678347928237575055799;
    uint256 constant log120 = 1447829506139581311583228319084949437104178180742382692931885257;

    /**
     * @dev Compute LogN(x) and N^LogN(x) (round down to larges power)
     * @param b, log base
     * @param x, value
     * @return log, LogN(x)
     * @return pow, larges power of N less than x
     */
    function logbaseN(uint256 b, uint256 x) internal pure returns (uint256, uint256) {
        uint256 logB;
        (uint256 n2, uint256 m2) = logbase2(x);

        if (b == 2) {
            return (n2, m2);
        } else if (b == 3) {
            logB = logb3;
        } else if (b == 4) {
            uint256 n = n2 / 2;
            return (n, 4**n);
        } else if (b == 8) {
            uint256 n = n2 / 3;
            return (n, 8**n);
        } else if (b == 16) {
            uint256 n = n2 / 4;
            return (n, 16**n);
        } else if (b == 32) {
            uint256 n = n2 / 5;
            return (n, 32**n);
        } else if (b == 64) {
            uint256 n = n2 / 6;
            return (n, 64**n);
        } else if (b == 5) {
            logB = log5;
        } else if (b == 6) {
            logB = log6;
        } else if (b == 7) {
            logB = log7;
        } else if (b == 9) {
            logB = log9;
        } else if (b == 10) {
            logB = log10;
        } else if (b == 11) {
            logB = log11;
        } else if (b == 12) {
            logB = log12;
        } else if (b == 13) {
            logB = log13;
        } else if (b == 14) {
            logB = log14;
        } else if (b == 15) {
            logB = log15;
        } else if (b == 17) {
            logB = log17;
        } else if (b == 18) {
            logB = log18;
        } else if (b == 19) {
            logB = log19;
        } else if (b == 20) {
            logB = log20;
        } else if (b == 21) {
            logB = log21;
        } else if (b == 22) {
            logB = log22;
        } else if (b == 23) {
            logB = log23;
        } else if (b == 24) {
            logB = log24;
        } else if (b == 25) {
            logB = log25;
        } else if (b == 26) {
            logB = log26;
        } else if (b == 27) {
            logB = log27;
        } else if (b == 28) {
            logB = log28;
        } else if (b == 29) {
            logB = log29;
        } else if (b == 30) {
            logB = log30;
        } else if (b == 31) {
            logB = log31;
        } else if (b == 48) {
            logB = log48;
        } else if (b == 56) {
            logB = log56;
        } else if (b == 60) {
            logB = log60;
        } else if (b == 112) {
            logB = log112;
        } else if (b == 120) {
            logB = log120;
        } else {
            revert('Logbase has no magic constant');
        }

        uint256 n = (n2 * logB) / DIVISOR + 1;
        uint256 m = b**n;

        if (x < m) return (n - 1, m / b);

        return (n, m);
    }

    function logbaseE(uint256 x) internal pure returns (uint256) {
        (uint256 n2, ) = logbase2(x);

        uint256 n = (n2 * logE) / DIVISOR;

        return n;
    }

    /**
     * @dev Compute Log2(x) and 2^Log2(x) using bit shifting and comparisons
     * @param x number
     * @return n log
     * @return m pow
     */
    function logbase2(uint256 x) internal pure returns (uint256 n, uint256 m) {
        m = 1;
        if (x >= 2**128) {
            x >>= 128;
            n += 128;
            m <<= 128;
        }
        if (x >= 2**64) {
            x >>= 64;
            n += 64;
            m <<= 64;
        }
        if (x >= 2**32) {
            x >>= 32;
            n += 32;
            m <<= 32;
        }
        if (x >= 2**16) {
            x >>= 16;
            n += 16;
            m <<= 16;
        }
        if (x >= 2**8) {
            x >>= 8;
            n += 8;
            m <<= 8;
        }
        if (x >= 2**4) {
            x >>= 4;
            n += 4;
            m <<= 4;
        }
        if (x >= 2**2) {
            x >>= 2;
            n += 2;
            m <<= 2;
        }
        if (x >= 2**1) {
            /* x >>= 1; */
            n += 1;
            m <<= 1;
        }
    }
}
