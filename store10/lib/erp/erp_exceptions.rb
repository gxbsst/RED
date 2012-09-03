module ErpExceptions
  class ErpConnectionException < RuntimeError
  end

  class ErpQueryErpException < RuntimeError
  end

  class ErpResponseEmptyException < RuntimeError
  end

  class ErpResponseBodyEmptyException < RuntimeError
  end

  class ErpServerInternalError < RuntimeError
  end

  class ErpResponseFault < RuntimeError
  end

  class ErpValidateException < RuntimeError
  end
end
