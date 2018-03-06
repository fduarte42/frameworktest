<?php
/**
 * Created by PhpStorm.
 * User: tito.duarte
 * Date: 06.03.2018
 * Time: 14:03
 */

namespace Application\View\Model;


use Zend\View\Model\ViewModel;

class IndexViewModel extends ViewModel
{

    public function getInfo() {
        echo "Created By Interligent";
    }

}