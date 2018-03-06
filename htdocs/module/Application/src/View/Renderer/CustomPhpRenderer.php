<?php
/**
 * Created by PhpStorm.
 * User: tito.duarte
 * Date: 06.03.2018
 * Time: 11:20
 */

namespace Application\View\Renderer;

use Zend\View\Model\ViewModel;
use Zend\View\Renderer\PhpRenderer;
use Zend\View\Variables;


class CustomPhpRenderer extends PhpRenderer
{
    public function render($nameOrModel, $values = null)
    {
        if (!$values instanceof \ArrayAccess) {
            $values = [];
        }

        if ($nameOrModel instanceof ViewModel) {
            $nameOrModel->setVariable('model', $nameOrModel);
            $template = $nameOrModel->getTemplate();
        } else {
            $values['model'] = new \StdClass();
            $template = $nameOrModel;
        }
        $output = chr(10) . '<!-- BEGIN TEMPLATE ' . $template . ' -->' . chr(10);
        $output .= parent::render($nameOrModel, $values);
        $output .= chr(10) . '<!-- END TEMPLATE ' . $template . ' -->' . chr(10);
        return $output;
    }
}