

package BasicParam;

  function automatic int clog2(input int value);
    int result;
    value = value-1;
    for (result=0; value>0; result=result+1)
      value = value>>1;
    return result;
  endfunction

  function automatic int BITS_BITSE(input int BITS);
    return clog2(BITS);
  endfunction

  function automatic int BITSE_BITS(input int BITSE);
    return 2 ** BITSE;
  endfunction

  function automatic int BITS_BYTES(input int BITS);
    return BITS / 8;
  endfunction

  function automatic int BYTES_BITS(input int BYTES);
    return BYTES * 8;
  endfunction

  function automatic int BITS_BYTESE(input int BITS);
    return clog2(BITS/8);
  endfunction

  function automatic int BYTESE_BITS(input int BYTESE);
    return (2**BYTESE) * 8;
  endfunction

  function automatic int BITSE_BYTESE(input int BITSE);
    return BITSE - 3;
  endfunction

  function automatic int BYTESE_BITSE(input int BYTESE);
    return BYTESE + 3;
  endfunction

  function automatic int BYTES_BYTESE(input int BYTES);
    return clog2(BYTES);
  endfunction

  function automatic int BYTESE_BYTES(input int BYTESE);
    return 2 ** BYTESE;
  endfunction

  function automatic int BASIC_TAG_WIDTH(input int MAX_MEM,
                                         input int CACHE_WIDTHE,
                                         input int CACHE_DEEPTHE);
    return MAX_MEM-CACHE_DEEPTHE-CACHE_WIDTHE;
  endfunction

endpackage: BasicParam
