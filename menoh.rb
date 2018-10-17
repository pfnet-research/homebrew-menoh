class Menoh < Formula
  desc "DNN inference library with MKL-DNN"
  homepage "https://github.com/pfnet-research/menoh/"
  # pull from git tag to get submodules
  url "https://github.com/pfnet-research/menoh.git", :tag => "v1.1.0",
                                                     :revision => "d395001026e1d761465fcb5322612a99aa6f74b6"
  head "https://github.com/pfnet-research/menoh.git"

  depends_on "cmake" => :build
  depends_on "mkl-dnn"
  depends_on "protobuf"

  def install
    system "cmake", ".", "-DENABLE_EXAMPLE=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>
      #include <menoh/menoh.h>

      int main()
      {
          return !(strlen(menoh_get_last_error_message())==0);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmenoh", "-o", "test"
    system "./test"
  end
end
