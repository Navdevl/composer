ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.12.2
docker tag hyperledger/composer-playground:0.12.2 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �W�Y �=�r�r�=��fRNR�TN�Oر���&93��|��ëh��x�d���3 9�p@υ��|©��7�y�w�� 3��ɒ��5�A"1�F�n40����&�*n���m��vM-�k��ѨL��c�0��BX��GbX��R$,Gb�1�G@����k;���c��n��[��W
d�:6��3������*��9 _&�m�~3����`��>e����F��,iud���D������I �ٖ�%l�?�X2;���2�R� xPN�>$
�\v��? �j���BK��m�v�|����A�����`��Y���M��|ddZ�0(�9�*��j!�V,T���Ԣj�bݛ���n�CL6�i"�Ý��~��l�<��C�t�l�FV-]]�}٪��)mZew$l �*��QpH������z��(;�b��n��D��C�&���Yԡa/lWo!��i�<li�"
�t��萖k����V�C!�r]�V�@��1!"̟v
��B���'V���@��j��\��9��b�|�W]�����qڤ�*bBw���2����n�n0�mtO�k��.������4S��̞.�!M�!�|S��O����1��k���#�}�DN[M��h�]�_HЅ�,�eer���r�{A^1xf7��N�.�D8C��u�b��<���������d1}"��������� �F��-�A�q�6��G�Ͽ(Il��F@eR.�d)���WO�Uu3T�v���k��O�Uc�4ݢf�|�J(��僣R2�Vx���&������``H<",_�������O���(�����/f��MXG�s���;����������z�_Н�p�{]خ��	)���t�<md�2+���Y�9�5l�Z�MO�i;��Zt;�۶�t(k��"Vd!�\w���u���r�w�6�Œ'�Jw���g�Ɔ��9'�C�i`k��)����3t�6k[!Z�@�?��'Hd�����X�.�V�j��x.P�2���62�X����ՐCo���8T]���Rz���u�h�@���gq �Iq����LD�z;��@)�)���4P�ԽGbP��y����O�SOuH� ;}�s�����`��O1�{;tWp��'����_DA^��U����=��5�d'��i@4u� �Ԁ�Z��H!�k��Y���a%�������;O�kL�@�����^o�7y(�����+J�$� ��=��I�����^�������@��'���tҸ4�8o]��z�vr��M��Z��m�OG13@<>j�-�����������pĴ����-gܫ��a�r<ưG C�c�iO�����&v�9Q�Y�:�������TE {S�M��dl|}ti�$���.}:ر"m�{�\��+���*Q�5L>��(�;,�w�CAHu@�����g~<�}�w�3��6؈�G��?�<m���|B=�&�6��۟���a�{�J�|�p����l2uz@�B����q��!�74��W`�<t�;~9���i�D��K��?�{;��p��h$���X	���l�������6��(K�i��翫�OJ��a<��;[`g4��3�]=�Y��9��f-X��4ײ(b5�����ʕv>��p��\�C9Y�Vv~&�	���g߳+�;�gO�Ɛ��(K�Y\/7�$J���t��;(����f��@ �\�F�K��n�6��
��&+���D2l4�&�H�ϞN>"�ҝ�u~��T�P���G��\O���]���6"��ٛ׺0Q{G�x}�~��v������E��o߂�3��3xj!��=nI�s9��mP �8�۪"�?~/�bn)i]:&K::=���!#���C����B��X~R��/g�a�U�sp�`'���e5���'	����X�_6���A˹��2����S�_,[��*����{�^����I&�0@ жPM� �u�2��k�sg���S����X����ϱ�����?W ���p�$���Fp=�+����]����������������z����pl�=�e; Y�^������B�Ղ�f9��]�C�u���ɵ����;?�l��~^|J��c"B��p���Ѿ�`�'v�vP� #�=k�w"��O�_�U��V,ԦJ��X�3a�FȔE���;M�РAR�X-�j���ˆW�+�6�2z�Sȣk2��b�E*��x�L�_O�s���{�L�N��5>�&��@�\�\�����KP���?&O������[������P&��\��?t��=[
Y�茨����kAnDk�ǁ�O�:n�  ���_���V�ٹM�������ЪU��M��.A��?"G��_��������qY,cK�7P2a�!���^C�p�����]����]^
-���N���Ww��y���f7D�;�Ч�C*n� �� �t'`�9 �ìci?�V���yT9�=� P���J��I S�Q׀ߵ9����Ķ�� }�?�p�FO�E/n�.�x���yI��K6`�*��g�v��"~?S���c:/�D�	&�,M��g���Vc*5��t�OgȘ�c��X�ɮNe�yz�{�O���Y�4e^����2|Xx��1�df]]�h@�,���%R��̻��^͘*���#~�p��`�>��۟��1I^���n=�##晧�s��:���
����O$"��?W��}�}���������������Z~�	���*�R|����(�a�Z�խx<Z��%Y�A$�H���j<,�P�G�q�ۊHխHd�?����57MxC��W��v�Љ�B�n������ۧ�Ħ�-Gw[���O��`��__m��I"���7_���<�{����������w���?�.{��ߜXd�j��xL��vX0�SB4�`�/������{�=���3�Vm�������_|��sLޤ�%�_�>�rT���*���c�g�[]#eÝ� �(�I���5�С���'O��3�,巯x[��s���8=�"�2�UŢ՚�ƶ��Vm+�j�\�R�FD&�[԰,�P܊�xU�A����&�!�+^EĬ��*@���Hgs�L�*�L.�TҬ�������dRQ�u��K(�\I)��q�EO%�=�&��t�(v����>�]�i��U/������*�Q:��'����K����	�J�YhT�F�~��E�\9򞩕�1y�'��L��qO%��Tں�V�7������e�={�hT�$�r�*	�)z8�JZ*4ޙ�����݆Z�W�n�<'�+9᠒�Nh�9+e�̓�D5_����i�X̦����.ӕ<8ڻd"�W�26<9먭H���>�'�^�/�w摔qs���I��)�W/ӵ|B`J�{R<)9�$���0�刁�G�^��B�ZI���L䳉��l9/Ǖz:�L����]E�)����w�(���E��?���X�~�wrq�)2'���Į��<9����)�S�2P+�z$;������B9����a)z&�{�zw�RI�����VKuӉP�H�x��R�t�wK��R�J+犒OڴWZ�[l�{J.ѲΠK��w�U�ov�Z�-�9xp`	�L4�K�#�D�ݼ��=#3�T���O%sŤl����d���Z9E���GN⡆y�"��EP�<9��;I-T��ˑ�(n^�4���6L��x�-�3��w����r<��
G%e��D>]H�P���C��O�ج��f�l̘�gk��A�rC}A�B�� ~&``�-��Ex˞�J������ M���������x��OX#�������tX����OY�c.���5YY�F'�BR�X�B������z(�7����فr,��7��=1���I!���W4%�A\�����N�.J��Q�2����r+i�UT���ͣ^��E2��JY��l��G��	IPUB�#���ڭ����'sÕ�z�>���r���������z�_|��߭~��/c��f�����+����(��K�/��f7�=���?�Jqx�R�j�XW�0ֵҙ��d^�/N�n���z�9|�9��i����7�q�o`��㶸��߼tL�e*�]q�ֻB|�m�+9�R�;;��4g�{�~;�	��k;����z�o�+aK�?z=�;"��?���$n�,�K��7��a�-�A	1�Ђ�ey�z������ܚ��m0�K�b���P����n�  R���:���5�M��H۠MX��O��%`b�]x�O�����'s��)=��� ��7� H���m0_���mJ�/���f�����(�*2p�� QSc ����ce�ct��v���e��y��K1�l{p�P�[Tx���N�>��>�#���8Z��23�"V�� ����C�jL�hd"g=�Z>=o�v-&WA ��6����]h�\J�T>蠗�6z|:��� 4�,أ�Bc��&��d��h۶NY"�N�T��oO�4��%�����bTL���)���д�|�t҃ct�d̰����f2���x��W��G�G���5DMϐ�$к��_�7�I����蓄�'Fl!�WW�A��� ��Ir��/$�禭�k�}2�h���5�3��C����JD��6_�m*hd�&�c�vz�k�2��M��<)���ue|�	��ؑql�8�\{�T���@��*�,b�Jpf�T�֜�ˇ3.|8�B\;�݋�4 "U���oJإH�B�mF�"���O�	�@�7�_���@��x��@O��bw�]���FzI��2�Q�J��J�/���4_�|mj�</��>9��C�w��V�ir,Wu<�TU��x38��L4{hٵC�ҁ�I�[���!FE5\�h��~�F����O�7�^&k�:��-T����1�\Eq�Ģ�H�P��v�!=Ƽ�C�?�a?��T&l�m����i7�m�T�X�C�̧�'st��}�1���S�#��(��T&$��� �*}f�d5���4�<c�@��NMВM����֑IVh;�~�da�������QIZ�����g�Zb��rwO�\�MO��~P0C�f�Q_��H�$�)���I���<Y\9��8q7v�$T,���H�b��`�،@�� ,b�����q�U�5�Vߺ�>����w���`(�%��?���o�K�/�=�k�o���s�������_��7��k��q�s��,��8z����:��
�n]C���ga*Ɋ�I��"����p�)��B����12܊�BFe� ȶ�r���$��G�������7�����凟����}A�������!������}���V����﾿`���?x���{���!�5����������i���� 톋! -V h1e��
l���F��cCK�R
���&�ҧL�s���r�B��{�����«\p�CW5�e�
�ݨ*�%0#�5�:�M��i%ab��&�^}.�
��kHֳ����=C��0�/鴍@���V��`r��x����|��́��u3A�w)��Ek�Nq��6�q��΄b�L�0�)7g���A%\��f3Y�։�!M3فyX��g{��;�5��~���:�F�}��_���@Μw��s�0���X?ŗF�˗ٱ�k�A'r�B��:�7��2���J��9S��2ee$�R�-$0��,by��B�Z�Nr �Q�K[�#��$�$��ɚ0�hg.�4��-�1����)t����Gt��"n*���� i�I�;
S�_-2�a����71�lѪ�H��b�C�r�`��d�j��X͔��qg��r��/O3�N�OִV���Y�T6�tr�g�&%��Frʏ�C
m!Z�K��l~�]����t�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%�py	c0�"o�R4x�$��?^�(%��cO�p���cLo�S�lӊ��b[���vV8�rr�D��A�C!U���A�ꉚ)��n����۩��?�n{���C������9Cd�x6d��FU,�zm��G�j���M��	����sS�<N��p�hjr,_���hl��6Y��V?��n�~"��>�ӱ0&!�2��-k9B�©�D��&ފ�<e���s�B���S�p,�#S.�|&;��ә2k&��j'�.Ȑ���d?�ӵL���Z6�'.�;��T�Q�MZyD�ڬ�����,J�K�̻��z�������oY��q�ڣ���-���
`�^�/���^	��g�{q�\l��a~���E���;G_�}���C��5�S�E/��7�@���˛�7�y��X�? ����� �o�@|�?�ƣ?u��?~�����z��ÿ�R�e��(������,'�*�g��,)�(��������u~��K�Ώ�|�2�`a9�,%r�Y���+���X�~Ʌآ�`rGt�Ʀ�	Lٕ�9 |�
L��H�L��(�Y)�aL��,�T��*0K<��L�8�>f�y%�+ 1*��N�� ��߬����o���E�M�����1o�i=ڮ.k�D����te�GM�&�9[�D���jY��I���d:u�N�t�o0"�i
�d�SP�8#5��@eh����v�8^9�D)9:�$�|���Q�J����>E�e'��Y��UZ�)�~��l�b�<TpLTj�p���,�F6т>��b!���Ƙ^`�8�e�J7�)Ǎ�0S�{�0����N|�ۿ�x�[W2M�M�P.��(ϗa��p�LN�L�����p�_����M9��+����]W?"W1�+r!��/�=n�e���6����3�{fVz\�ew���;m�]w�g��~��M��pĿ�\�C˞l�j5�7fI�g�D=���l���Ò�͠���Z(���2�g�S�(F�,1��\��<=���^mdi�T?�fNߡ�Z�M�P�lC9.дyj3K��L~Dw���@�:�|��$R�YGkO�#������Z�`��|�O��-U]�*,�.-H��V-�W����NU�bYs�Rd�F�P�7�yC�R�bQ��Ê�h2�l��)��"t�5\�W�u�~�1B��Q4�,<��M�WW�DV�d�R$Bv6(��552����RHزJ�&�_E22���H�	�~Ԑ��I*�G0�2AVv��D��c�2)s�U(��{�B)���B��:���uJ+�9$O�j��pI�?��:ݮ�Y�P�;�<Ǹ�ѱR=�������V.�*�dH[F�3�.��Qn�PW��P(�r�.������piJ
^ԇf�����y�S�y�� }),����)��f�R��;�4YhΧ8)W�tC�k��<O�HX#H���&��Q�1K�:6�MS`��QXbe��Bl4Z�X)�j9�2f�����.����,��.}7���t�
��x�2���|�B��K�C�-*�1Q��b�#7�_F~��*C}����xxySi#/�c�g�huK�R	�x�y���s���σ^�o!��<��()�n�M�b���S����Q�4U�}H���5�I\����)I!ki�3�*��i�8"�����8Xɐ�%��s:�Sw�V����G8�C��D�uE��Gȇ���)z��p/r/�r��f�wHwI����D��z�_�����Q�-��~�����r�@}�l?t\�:=	�j��@��kH7�˝AM%�@/�r�ke��G���aU�Ki��]�ȍ;��� �H;�q9#�O`�E�O�#c��gv��~��������?uް6�B_ː�K���<~�:����>����غ]�-z�:@N�J[Ŝ���Ɏv�l>P;������cu�euɆ���ãqя�E�#~?zX҂�c�|�� Sk��~��B-� �g�+bw��/��7���B;�z�M-�18��b�`��I0�A�;�jrp�X:
 ���T���Ԟ���pe Y|�B�Al��ja�C�٤�$����(�Џ�����p�Dd-:����>�����Z�i�zW�x��L����w��~t�W��"5�Z�,� ~Ҋ�y֫������U'.��&;��X2����ں���x��U��.�#��+b@}�&:���Y,@'�L-�q�Or+! l��D�Ա���#�F���������	�˭~f@�����9���O=����3[��\;ؐ��_����bS��_��,���UM��d����s��EC��ӡ#�-��6���҂��u�&����-o�C�b�$4`en��f#�O�(�-`��ɏ ��$~y���|.��t��qp��"(�fK�-�x�Kv��V�>aP�:W�&���+���h�R����E�<����v ����{���]�LR5�2�U�?��!��q_j�%v�4a� ��m{[�'<	^��v�O1��1��_i P�P�X�A?MI�#�T�l����Y�I���k)�΂�������2k��I .�rXǚF��A�.�����:�v5`U;V&k( ?��=n�ܩ�!c���5�SK��f��aM�=W���v� �p?2m��_Y�LTI��%�����ӕ�s��Zv�E���]Z_�b�F��ދ޿ �>��	p�mX���n�����!�"T�i|��U��m��j>���&�ĉ�3#��ON|-3�Q��Ú�C��y�M�$p��:��u_Eٜȝ <t�ϟ���Ñ�n��mm�i��<�@���#V��9�1��.���E�[@�BSv6��
t"��{��}���f*�9����n)�pḡ|zl?�@�)����1����Zl�X����:�����v��+۸��?!6���v8��G+��$��l�dG�[V�`j'��2�6<�{�	�)��8}"c<C���Ρ�K\���oYڪbGg��.+>�%��5_�Z���>+W4t��o֎D���T���&��D��٦�v���q9��%�h���c��l7�1J
���DPҙ޷P{���A�;�
|����n�I+��fl�7��z����(v,�7av�}eq�*�ԤH��lb�(�%'�p�b�$QT8�D�(UBRS!$��5�ј�(�DI�51�'M;��	�96�O�O�l�,�m����)z�sKBO�;g	��dg�=�]Tleܵ/�Y~G�+8vW���6Wd��E�I.���Y&��p.�LV��������ei�-r��3ZW؅���%�$pb*�>�G�Wd��^����.T���<�>��]�D����@�g]�\T���#;���:hg��P}�B;�ѝ6!-m��:Ӻ*v0:�2����m��6��ӵ���vn�(t�	�nus���w���KS.&��(��{<W� �'�l�,�q�B���)���s�*��,ǔ��Y+��e�9>+>���	����5:�&�d:tl����>aI���E������v�l£�;����U4�+��\6�'ϲ�X�Okt�\6:�_�]ot�u���L�S��<-��yt�c��"pl�*[i����H3t�{!OY���\9�bgL�_��S�X4�B�����Q��3{��䳶���,��/�7��]�����������͢��m7�o��-ۅ~Lv��
�.+ce(�g��;�ڼwI a�R�nm��\��
ɻc����p�8b��r1c5�8B
8*:�����n�߮l�n�%Lb�C��}�;��6��h�����w���H/|��d�m�?DD����#���I|��7v�����������t�������������B����*��6�?	��>Ҿ�?�y�'�����lڗ����/Nn~�����}/����������z��o��Qz%�?rG�������/�O�c��l+XkG�2nɎ0���v�l)�ԊE�xK��X�j��H�	G�&&+x��Zg�ˢίvz��!
߶����|��f����4��5uh�ÑVF��s�"��є�0p��Ns�|]W��ʌ���J�s�]�� ��R�9,�"ch$[\�O�Ѳ���m��!iY�����I)]�M:�⤫��Sf5IƻcTc/������_~z�������˗�66��yH��>��6��8u8��Gz�?��8���>Ҿ������W>��A�߿��:�##����G�g����=_�t������l������W@�ë� t8%�:�����w�OR��:��}�WK�C?��P��K�����?��%������>�!T�!T�!T�O4��N镰�����g�ںE��;�b�;F����8�TDP�� "�������I��v'�� ]Y�)e��Rt2�\k��?JA���B�_�������O�� ����?�V�:��v���C�o)x��7������)u���e��>�r��ʖv.���������?���'�3������}x����|l�3���'�J�|����m�Y8FO�]���R�ݳ�����f����ϭ�4�T���Ŗ�8��=��w���XyȢh����m�c����������m����϶���L&�|/,~�n׈ӥ�EB�GC�$��t��/�-��{��y�l��r/L]9��ȉcc�hD=��5��/M�wE�=�}����ش�C��a�c��V��_�T%,1�;����f�B�A��2�@�=-��P����������P/�����Q���A������'����j����Wj���(���� ����������_���/�������'��?��W�7���K��}���n�鞟Ӹ�q4���������W�������>wƣ�&�}Y����:v�4䩇�/��k�����Z1ܥZ����.�8)�����=EP�Nb7�Θ������R�7ۛ!�뚜=���_����������wD��s���_
��+	��6>r�㿷�o^~��P�JFx����X��h|HI��.Vڔ�	:!�Ͷ��Q����u"��p暤 ���n�Prd��N<;����Z�����+j�����Wj��V�9�'� ��
 ����u���{�)�����N�?�{��)l�46�X�#Y
�8�Ѐ�X��}��	�pi��	�G	��)�#<4@ጀG��Q�?����W��gE�Q��HH�VS��,����N���1�,[�dzm�%��`ٙ�9���ѓ��p�j���i�.z�n59���I�!zَ��,�#I�{tp���6C*l���Iqg��/�p�����P��C׷R����_u����Oe��?��?.e`�/�D����+뿃n��A���8dB98�9ͧm�z;��,g�Sf�%�[�'��/��pЌW?gt�K�n�%����f���!�U�ÌЏ�d���9΅��а��:�����GU�iy��{Q��?�oE����w��w��k�o@�`��:����������Z�4`���c�;�G����[��).�/����Br�y78�'L�$ar$��w���e%��?����6�����Ϝ�<=�g  ֳ� �HU�=��%�P�"�C �<�7���*�l��	��_�+g7G�VSP���km��)�b��P�z�:��Y�����I;�s�E��%��7�e��9:�}7_��5������3 �%�p�vB(����D��;��.�i�� ��Ǒ y,V�w�@(�H���>�f?�I[�41|�@0��&4��F����?�Ը���o�?i��5�y�������-|�1��!��sI�m���o�#2͖�	ˀkfҷ�"A��~�hr��jc6O��5���U�s�ދu��@���������}&<�2��[�?�~��b(��(u�}�����RP
�C�_mQ��`����/������������j�0�����?�s=�r=�CIef���G]�u]�&��AY�כ]O�p	��\@2��n ����:����Q����_9����êPR�����#T��/�$='�vD����A/��P�&i(ΦY�K-�(m=l;챑�͚�i��w�>�����G4��d,8�:�m�\o�9�iY�>J�[0��^���������|>�_#�~���C���?M`����Z�?}����_I(����:���:���j��\u�����?����\���?��N�����7�߯�__�>������8ϚB��L�(�W�q7����K�{���q}������1�gf���l�g��|l��{wL�;Ղ��9��>��I0���dZ�(�}M����������V����Uy����(�4�a�4�X�d�L���C��v��K�zO��k/Wz�z�^�N(�c�[X�����!�ao���m�6_q��*�h-»T�t���Tv�k�-*�Hf�A#�n=k��[pԘk.6N��*07c;qGq��ФT:Y���,i%r��J�q��D&#�3p��,�s������Xvi�����=8��"����|����������8F@�kE(��a�n�C��`��& ����7���7�C�����}��PK@����_���աt��\�������_����@�/��B�/��V�������+��?d�Z��<F��#�?	�)���(z_���e�,�<������_=����U�b��p����_9�c�?@����?�CT������zp����z�?�C�����G�H�(�� ������)�B�aw�/����?��P�m�W����?��KB���B*@��G�$�?������������H�A8D����k�Z�?��+C���!�F-���$�?��������j����KA�_�0�_�����������+���怒V������?��W�������W��?�Z�?���@����Up���.��@����_��x�^���C���.b�C���ϰ��Y.��������$hv�>A������y㺜K������/����A�_�T����R�G�����ݹT��?U�B�ݫ7`!�*y�'�I�䢕G#N��&6	��8��qK
�b��������Q�[���*Z��4����!B�V��Rg��=���(㍝$�����M�>�{R�B�u h�D��vwO���f����?�C���}]�JQ��?�ա��?�����{����U�_u����ï��>�Q�ƾo��FM�}�7��r0+��˿la���̧��}���`�7f�M�߰��n�̢� ��E�C�*ap�N-e۴�����b����v�դA���f������f9XȔ��{Q������������}��;����a�����������?����@V�Z�ˇ���������?�����?���q,��91��B����_+����Y�]��$8���Ro�X"���#Ҟ�[���lH���I�3M��`$2���8R:����k��1�3r���P]�K�(��vNd�~�z!��9�[��i�$G��8|y��O�N���vK�5��^�	��.�;~�kț�}��;�0z�8$�Ŋ���:TX�'}��g:i������k�!*���[N�g�&��ؙ�w���>�N��<�F��rT>��dF`��&
6W�1�x<	�΄j�-�j�7)�l�����?���n�^�^�������R�����?~�������:�� ���K�g���`ī�(���8��(� ���:�?�b��_�����Ϲ���Q?����������H���+o��%����=�Cӏk#�L"�a�Л-\B�������?Zo��?D�u�4��ώ�t�Q�^i�|����?Y~�G���Y~�w�������_[��&�7�rx�.���5��sl���-!�_�VE��j��_���0쑯�i#�cs #J��k���mt��b���8{tS	q�hX)��<gN�&%�{�NǶ��m".��1B�b�K06�X|��E�>YyO�;��s��eͅp*_��%~p����o�.��&>�'fRhD�(0vojm��`l7E��0��F�=6;�X�ɗv��%����e�/	2	������d�2���f�1�X�d�q��1NXb6B%"��
�y��w��@��F�:rS"��8��3�Rܗ_��Z�?�n���%���x���z̜�H��意���I���(��8=��Ips�`<ڧ|4�8�P��f�g������E���_)��������?(�ȋ=���n:�[wy�'�P�|�/!x����+V+�G��U����{�ٟ������������:�?�!�������?85F��M������A������^q�������g�}+���0>�23�г����V�����^��z����1�o�m����j�!���&�`߼������~��|?���f�
��a�HwR:ZK��9>�3n���5�x�N#Z�'R>͋k/𳴝�O�g�|\L֭n)iwt�����~7�y����\�#�o�o��q�`���N����Ҵe&�1�LW�"�}?>���`��0ka��#��	C�&�K����4����}D��T���)��k.�M� ��7����M_�b��;+�b���~7�A���`���p��\�'��fY%�,�_;~>}��b�`�y����ˢ���/�`�b��uyc9̿OD����?�������+��V�^�m,�Z��9,���� V'r��P)��2o�h��D/���˖�jA>*[��{/>�������(�e������
�����w���p�c-��_5�C�Wu(���c �T������A����������޷��i��(��������YxX���_��`k�r��>��U�۹��Z_�B�o"��H�Lh���/�.��z�\S���=���r�ֹB>ں�u����+���忧�vk���o�ܟ�Ķ=�;7'u���t󐇞:�U��`�~{�V  > E����B۝t�3�̤�L\�������k���ڻ���^��:'�xZΣ��:���֝�=����5�U���7[Da5v�C��j�
���3�ŽͬL����*�-9�rE�Zןn[�f5�R���B|^��z^�Qj
B�8��,E�+�`�7�&����ص�ao��]�/�[R�����p��lIV�����{]e!4�]Ø�:�<�j}��~U��{��o���Y�z���ve���l����Ty�2�cU���RI��R��J��g.��Ƀ�G][��2!�������+��߶������Б��C h�ȅ���!�; ��?!��?a�쿷��s�a �����_���ё��C!�������[��0��	P��A�7������{������~�,�������lȅ���ߡ�gFd��a��#�����%��3���エ� ��G��4u��?eJ������G��̕�_(��,ȉ�C]Dd���W��!��C6@��� �n�\���_�����$����۶�r��ŋ���y��AG.������C��L��P��?@����/k��B���۶�r��0�����?ԅ@D.��������&@��� ������+�`�'P��cC�?b���m�/��\�� �_�����T�����d@�?��C������`�(���y#/0��G���m��A��ԅ��?dD.���h�2I���Y�(34��u�L��ais�XbM�/���p�e�e-��2&Y&�"Gr���nݟ�<�����!�?^����2J�"�Q�>��r]��BSl��q+��L9�]����q�.�d��cݮ�q��ɝ�E���j-Nc�~���Z�vĆ?��=�nJ���NW���n��Q�tA�K!1��C��F+�%�s�!���T��f��۱kՈ�\Q��ŉ�o}�.I�Qi��Y�U糿wqQ�<g������@��Gk���y����CG��ЁR��x����[�vɃ���������ݤ�]�ס��D$��o�a�e��i[�wQm����g��Q���V{���F���mm��&�K;,�p�_K��vǷ�E��6��\���<F�j�]�cW��+9��)�N����k�G�_��_D�����~�F����/��B�A��A������h�l@����c��/��_|��ߣ���l��[v������U9rU���Og�զ?���|��&�d��W�Wv�8�z�{9�&�� 6�޸˒$��Ϣ�nQ�{cM�ۺ;)�%�>�+�|HZs�T��rb�y�ɦ� ��m���_ԺڮR
���VK�"n�s������WYü�0������k�Ѯ�ĮQyLS�������"<ڂ�s�'F_���ܬ���_i�4��6���|5��
�p:��m�RTW6jͽU�5�]�a��L��� ��RT�0�V:�0�����o���1��;p\�6dRk���k��6�K�`�Q,�B�[��O;@�GN������y%��,B�G�B��+�_<�d��O/^���>=�������&/��gA�� ���I`�����G��ԕ������bp�mq�����#��J���fB���@fOV����S��?�����������2��_& ��`H�����_.��@Fn��DB.��2�����L�f��)���>�(Qi������V��M��e\�h�l�?���}�����܏4��c����܏�ð?����~`����4��s�o�9��yx{]�o��D�zW<Q�:��$N-T��Y[v�2�a��Ƽ��Z����z�ِ���X� mt�}9�3FK��4��T�Q|u���b4��9����������v��%�Q��#M���b��i��-Ƃ2]��v=�Wp&�qՙ�:5X7�E�	Ϭ&mI��$��p���H����k���"�k.��Y��݇��T�P��>~����\�0����ߋE�Q��-��m�����GF����%�dJ.��+��(�����������B��30������E�Q7�M��m�����GD����0 �������d|���T�������k��0p\�4R[��9�T��5����Ǳl?O��Ʀ�66��s���� `O�|�(��m��?L�mh��QR*�Ap�������7mڢ7K�/�͐��h�Q���E�8Z�Q;ԋ\��J}cYVȇ��9 X��gr �4	��r z���7օE��]J��h9_�2��|ˏB������ړe�+)"�7-�?T�I9��ה�� qH�:�tkBu[��pz7������������ߧE�Q��m��m�y��"u��c�?��L����[�Z����"��K��S,m�4Y*�,eX�Ɠ����sf���s������3�����'��gÏ\�s����ø%�a:��6��Ӏji�r�뇓Y��Z��9�ʅ��?���7����.~�U��n�'"�٫��W�/|��i��~�r��C��aG���\=��ubO��\� ;�M`��ג����i��.��n�<�����#��?�@��O� &n ꦸI������G��x�/�5�#�"1'�
�b��Rl���CTk��)ዱu���ח��v8�Ҿ�W����eքS�1��ѱ_��8��:= �ǖ{�_5�����S=���B���ס59���k�G������Y���74X !�����/d@��A�����(��DC�?�-����o�����������𹱻�X] ��h�%݋�����#��?��=/�2���Ý��r�VӺ����j�a�\�4�X-j�ܢ󩌭��������q�I0Xl�m�PZ'V{h~��u�4+��mq�����K3K�<Q�z����Ui�SQ��B��	����ĸ)}�/�]K0)�NΟ���T��h����"�āl[^1
'�ʻ�HƘz~sO����ArӬfum8없�T�ڶ�l/b_i*��J�zj�l��!�#��.�%��CḶgǖ5��X������Xc�
�r�����x_m�hu�7�3�;N�U��ɿ����������w�z~^�gC�I&�����Iw�πswn�.��3-2���������Q�$�z� �k��S��RM����;�
v�/:�����r�&.=�9��� ':!~��"�k�X����;���^O7��������PR`&�������A���;~�T���O���Ƽ��O������>\|�g|c��ⸯ�?h�O�?��{��_����^=8�a��A�����q#\[��'f������3��{*fd���1r�W��Ą�T�🝫m9��'=�h:-L����o���^p�*J�û����9��H6<����_D�_��o{R������������y�*9*���_�����ӎ�?�}�?>OT$��6�κܟ�r���f��-v�av>~7O�>֒v�� �}3X�s����G��t%�9��%���sӇx�H�/ع����:����w�O�	Ý�)����|(�j{8�������6��f�˵}�µi���59������'�<_sr������^`S/���??��C�y����$K&��0��M��A,>7��3\��dU�q딒q�_\�]r�I�^�c�Z�}l�;R�US��N��$��]���y�¯?)��ݫf������?u��}~O���d                           \��q��O � 