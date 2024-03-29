#!/system/bin/bash
function UnpackPayload(){
    echo "正在解压payload.bin"
    python3 ./payload/payload.py ./tmp/payload.bin ./temp
}
function UnpackSuper(){
    if [[ -e ./tmp/super.img ]] ;then
        mv ./tmp/super.img ./
        source ./unpacksuper.sh
        mv system.img system_ext.img product.img vendor.img odm.img ./temp
        rm -rf ./super ./super.img
    fi
}
function UnpackBr(){
    for brfile in $( find ./tmp -name "**.br" ) ; do
    echo "正在解压$brfile"
    brotli -d ./$brfile ./
    done
}
function UnpackDat(){
    if [[ -e ./system.new.dat ]] ;then
        echo "正在解压system.new.dat"
        python3 $bin/sdat2img.py system.transfer.list system.new.bar ./temp/system.img
    fi

    if [[ -e ./vendor.new.dat ]] ;then
        echo "正在解压vendor.new.dat"
        python3 $bin/sdat2img.py vendor.transfer.list vendor.new.bar ./temp/vendor.img
    fi

    if [[ -e ./product.new.dat ]] ;then
        echo "正在解压product.new.dat"
        python3 $bin/sdat2img.py product.transfer.list product.new.bar ./temp/product.img
    fi

    if [[ -e ./system_ext.new.dat ]] ;then
        echo "正在解压system.new.dat"
        python3 $bin/sdat2img.py system_ext.transfer.list system_ext.new.bar ./temp/system_ext.img
    fi

    if [[ -e ./odm.new.dat ]] ;then
        echo "正在解压odm.new.dat"
        python3 $bin/sdat2img.py odm.transfer.list odm.new.bar ./temp/odm.img
    fi
}
function UnpackImg(){
    case "$Merge" in
        "out|OUT|Out|")
            if [[ -e ./system.img ]] ;then
                python3 $bin/imgextractor.py ./system.img ../out/
            fi

            if [[ -e ./system_ext.img ]] ;then
                python3 $bin/imgextractor.py ./system_ext.img ../out/system/
            fi

            if [[ -e ./product.img ]] ;then
                python3 $bin/imgextractor.py ./product.img ../out/system/
            fi     
            
            if [[ -e ./vendor.img ]] ;then
                python3 $bin/imgextractor.py ./vendor.img ../out/
            fi
            
            if [[ -e ./odm.img ]] ;then
                python3 $bin/imgextractor.py ./odm.img ../out/vendor/
            fi
        ;;
        "Lnside|lnside")
            if [[ -e ./system.img ]] ;then
                python3 $bin/imgextractor.py ./system.img ../out/
            fi

            if [[ -e ./system_ext.img ]] ;then
                python3 $bin/imgextractor.py ./system_ext.img ../out/system/system/
            fi

            if [[ -e ./product.img ]] ;then
                python3 $bin/imgextractor.py ./product.img ../out/system/system/
            fi     
            
            if [[ -e ./vendor.img ]] ;then
                python3 $bin/imgextractor.py ./vendor.img ../out/
            fi
            
            if [[ -e ./odm.img ]] ;then
                python3 $bin/imgextractor.py ./odm.img ../out/vendor/
            fi
        ;;
        *)
        echo "所以你合并到哪里？？？？？？？？"
        ;;
    esac
}
